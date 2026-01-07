-- rift-workspaces.lua
-- Sketchybar integration for rift window manager
-- https://github.com/acsandmann/rift
--
-- SETUP: To enable event-driven updates, add to your rift config.toml:
--
-- [settings]
-- run_on_start = [
--     "rift-cli subscribe cli --event workspace_changed --command sketchybar --args --trigger rift_workspace_change",
--     "rift-cli subscribe cli --event windows_changed --command sketchybar --args --trigger rift_workspace_change"
-- ]
--
-- This will trigger sketchybar updates whenever workspaces or windows change.
-- Without this, the script falls back to polling via front_app_switched and routine events.

local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

-- rift-cli path (homebrew install location)
local RIFT_CLI = "/opt/homebrew/bin/rift-cli"

-- Storage for workspace items
local spaces = {}
local spaces_visible = true

-- Helper: Get app icon from bundle_id or app name
local function getIconForApp(bundleId)
    -- Try direct bundle_id lookup first, then try extracting app name
    local icon = app_icons[bundleId]
    if icon then return icon end
    
    -- Extract app name from bundle_id (e.g., "com.apple.Safari" -> "Safari")
    local appName = bundleId:match("%.([^%.]+)$") or bundleId
    icon = app_icons[appName]
    if icon then return icon end
    
    -- Fallback to default
    return app_icons["Default"] or "?"
end

-- Helper: Parse JSON (parser for rift workspace output)
-- Rift returns: [{"id":"...","index":N,"is_active":bool,"name":"...","window_count":N,"windows":[...]}]
local function parseWorkspaces(jsonStr)
    local workspaces = {}
    
    -- Extract each workspace by finding index/is_active/name patterns
    -- We process the whole JSON and extract workspace info
    local idx = 1
    while true do
        -- Find next workspace start
        local wsStart = jsonStr:find('"index":', idx)
        if not wsStart then break end
        
        -- Find the next workspace start or end of array
        local nextWsStart = jsonStr:find('"index":', wsStart + 1) or (#jsonStr + 1)
        local wsChunk = jsonStr:sub(wsStart, nextWsStart - 1)
        
        local workspace = {}
        workspace.index = tonumber(wsChunk:match('"index":(%d+)'))
        workspace.is_active = wsChunk:match('"is_active":true') ~= nil
        workspace.name = wsChunk:match('"name":"([^"]*)"')
        workspace.window_count = tonumber(wsChunk:match('"window_count":(%d+)'))
        
        -- Extract bundle_ids from windows in this chunk
        workspace.apps = {}
        for bundleId in wsChunk:gmatch('"bundle_id":"([^"]*)"') do
            table.insert(workspace.apps, bundleId)
        end
        
        if workspace.index ~= nil then
            table.insert(workspaces, workspace)
        end
        
        idx = nextWsStart
    end
    
    -- Sort by index
    table.sort(workspaces, function(a, b) return a.index < b.index end)
    return workspaces
end

-- Create or update a workspace item
local function createOrUpdateSpace(workspace)
    local spaceId = "rift.space." .. workspace.index
    local displayName = workspace.name or tostring(workspace.index + 1)
    
    -- Build icon strip from apps
    local iconStrip = ""
    for _, bundleId in ipairs(workspace.apps) do
        iconStrip = iconStrip .. getIconForApp(bundleId)
    end
    
    local hasApps = workspace.window_count > 0
    local shouldDraw = spaces_visible and (hasApps or workspace.is_active)
    
    if not spaces[spaceId] then
        -- Create new space item
        local space = sbar.add("item", spaceId, {
            icon = {
                font = { family = settings.font.numbers, size = 16.0 },
                string = displayName,
                padding_left = 6,
                padding_right = 6,
                color = colors.icon,
                highlight_color = colors.icon_highlight,
            },
            label = {
                font = "sketchybar-app-font:Regular:12.0",
                string = iconStrip,
                width = 0,
                padding_left = 4,
                padding_right = 4,
                color = colors.label,
                highlight_color = colors.label_highlight,
            },
            padding_right = 1,
            padding_left = 1,
            background = {
                drawing = false,
            },
            drawing = shouldDraw,
        })
        
        spaces[spaceId] = {
            item = space,
            index = workspace.index,
            hasApps = hasApps,
        }
        
        -- Click to switch workspace (rift uses 0-indexed workspace IDs)
        space:subscribe("mouse.clicked", function(env)
            sbar.exec(RIFT_CLI .. " execute workspace switch " .. workspace.index)
        end)
        
        -- Hover to expand and show apps
        space:subscribe("mouse.entered", function(env)
            sbar.animate("tanh", 25, function()
                space:set({
                    label = { width = "dynamic" },
                })
            end)
        end)
        
        -- Collapse on mouse exit
        space:subscribe("mouse.exited", function(env)
            sbar.animate("tanh", 25, function()
                space:set({
                    label = { width = 0 },
                })
            end)
        end)
    else
        -- Update existing space
        spaces[spaceId].hasApps = hasApps
        spaces[spaceId].item:set({
            icon = {
                string = displayName,
                highlight = workspace.is_active,
            },
            label = {
                string = iconStrip,
                highlight = workspace.is_active,
            },
            drawing = shouldDraw,
        })
    end
end


-- Update all workspaces from rift
local function updateWorkspaces()
    sbar.exec(RIFT_CLI .. " query workspaces 2>/dev/null", function(output)
        if not output or output == "" then
            return
        end
        
        local workspaces = parseWorkspaces(output)
        for _, ws in ipairs(workspaces) do
            createOrUpdateSpace(ws)
        end
    end)
end

-- Initial draw
updateWorkspaces()

-- Observer for workspace changes
local workspace_observer = sbar.add("item", {
    drawing = false,
    updates = true,
})

-- Subscribe to relevant events
workspace_observer:subscribe("rift_workspace_change", function(env)
    updateWorkspaces()
end)

workspace_observer:subscribe("front_app_switched", function()
    updateWorkspaces()
end)

workspace_observer:subscribe("space_windows_change", function()
    updateWorkspaces()
end)

-- Also poll periodically as a fallback (every 2 seconds)
workspace_observer:subscribe("routine", function()
    updateWorkspaces()
end)


-- Spaces indicator / toggle switch
local spaces_indicator = sbar.add("item", "rift_spaces_indicator", {
    icon = {
        string = icons.switch.on,
        color = colors.icon,
        font = { size = 16.0 },
        padding_left = 4,
        padding_right = 4,
    },
    label = {
        drawing = false,
    },
    background = {
        drawing = false,
    },
    padding_left = 2,
    padding_right = 2,
})

spaces_indicator:subscribe("swap_menus_and_spaces", function(env)
    local currently_on = spaces_indicator:query().icon.value == icons.switch.on
    
    -- Toggle visibility
    spaces_visible = not currently_on
    
    spaces_indicator:set({
        icon = spaces_visible and icons.switch.on or icons.switch.off,
        drawing = true,
    })
    
    -- Update all spaces visibility
    for spaceId, spaceData in pairs(spaces) do
        local shouldDraw = spaces_visible and spaceData.hasApps
        spaceData.item:set({ drawing = shouldDraw })
    end
    
    -- Refresh to show active space even if empty
    if spaces_visible then
        updateWorkspaces()
    end
end)

spaces_indicator:subscribe("mouse.clicked", function(env)
    sbar.trigger("swap_menus_and_spaces")
end)
