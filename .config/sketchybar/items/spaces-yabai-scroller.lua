local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

local spaces = {}
local space_has_apps = {}
local TOTAL_SPACES = 8      -- Updated to 8 spaces
local spaces_visible = true -- Track if spaces should be visible

-- Space name mapping based on yabai config
-- Display 1 (Horizontal): A, F, B, W (spaces 1-4)
-- Display 2 (Vertical): D, X, O, S (spaces 5-8)
-- local space_names = {
-- 	[1] = "A", -- Browsers (Arc, Zen, Chrome)
-- 	[2] = "F", -- Fusion 360
-- 	[3] = "B", -- 3D Printing (Bambu, Orca, etc)
-- 	[4] = "W", -- Utilities (Wootility, Ice, Stats, etc)
-- 	[5] = "D", -- Discord
-- 	[6] = "X", -- Terminal
-- 	[7] = "O", -- Obsidian
-- 	[8] = "S", -- Music (Spotify, Music, eqMac)
-- }

-- Initialize: assume all spaces might have apps
for i = 1, TOTAL_SPACES do
	space_has_apps[i] = true -- Start by showing all
end

for i = 1, TOTAL_SPACES, 1 do
	local space = sbar.add("space", "space." .. i, {
		space = i,
		icon = {
			font = { family = settings.font.numbers, size = settings.fontXL },
			string = i,
			padding_left = 6,
			padding_right = 6,
			color = colors.icon,
		},
		label = {
			font = "sketchybar-app-font:Regular:12.0",
			width = 0,
			padding_left = 4,
			padding_right = 4,
		},
		padding_right = 1,
		padding_left = 1,
		background = {
			drawing = false,
		},
	})

	spaces[i] = space

	space:subscribe("space_change", function(env)
		local selected = env.SELECTED == "true"
		space:set({
			icon = { highlight = selected },
			label = { highlight = selected },
		})
	end)

	-- Hover to expand and show apps - smoother animation
	space:subscribe("mouse.entered", function(env)
		sbar.animate("tanh", 25, function()
			space:set({
				label = {
					width = "dynamic",
					-- padding_left = 8,
					-- padding_right = 8,
				},
			})
		end)
	end)

	-- Collapse on mouse exit - smoother animation
	space:subscribe("mouse.exited", function(env)
		sbar.animate("tanh", 25, function()
			space:set({
				label = {
					width = 0,
					-- padding_left = 0,
					-- padding_right = 0,
				},
			})
		end)
	end)

	space:subscribe("mouse.clicked", function(env)
		local op = (env.BUTTON == "right") and "--destroy" or "--focus"
		sbar.exec("yabai -m space " .. op .. " " .. env.SID)
	end)
end

local space_window_observer = sbar.add("item", {
	drawing = false,
	updates = true,
})

-- Update app icons in spaces
space_window_observer:subscribe("space_windows_change", function(env)
	local space_index = env.INFO.space
	local icon_line = ""
	local has_apps = false

	for app, count in pairs(env.INFO.apps) do
		has_apps = true
		local lookup = app_icons[app]
		local icon = ((lookup == nil) and app_icons["Default"] or lookup)
		icon_line = icon_line .. icon
	end

	space_has_apps[space_index] = has_apps

	-- Update the space to show/hide based on apps AND if spaces are visible
	spaces[space_index]:set({
		drawing = has_apps and spaces_visible,
		label = { string = icon_line },
	})
end)

-- Check which spaces have apps on startup
sbar.exec("yabai -m query --spaces | jq -r '.[] | select(.windows | length > 0) | .index'", function(result)
	-- First hide all spaces
	for i = 1, TOTAL_SPACES do
		space_has_apps[i] = false
		spaces[i]:set({ drawing = false })
	end

	-- Then show only spaces with windows (if spaces_visible is true)
	if result and result ~= "" then
		for index in result:gmatch("%d+") do
			local idx = tonumber(index)
			if idx then
				space_has_apps[idx] = true
				spaces[idx]:set({ drawing = spaces_visible })
			end
		end
	end

	-- Always show the focused space even if empty (if spaces_visible is true)
	sbar.exec("yabai -m query --spaces --space | jq -r '.index'", function(focused)
		local focused_idx = tonumber(focused)
		if focused_idx then
			spaces[focused_idx]:set({ drawing = spaces_visible })
		end
	end)
end)

-- Also update on space change
local space_change_observer = sbar.add("item", {
	drawing = false,
	updates = true,
})

space_change_observer:subscribe("space_change", function(env)
	local focused = tonumber(env.SELECTED_SPACE)
	if focused and spaces_visible then
		-- Always show focused space (only if spaces are visible)
		spaces[focused]:set({ drawing = true })
	end
end)

-- Spaces indicator - switch icon (click-only trigger, no hover)
local spaces_indicator = sbar.add("item", "spaces_indicator", {
	icon = {
		-- string = icons.switch.on,
		color = colors.icon,
		font = { size = settings.fontXL },
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

-- spaces_indicator:subscribe("swap_menus_and_spaces", function(env)
-- 	local currently_on = spaces_indicator:query().icon.value == icons.switch.on
--
-- 	-- Toggle spaces visibility
-- 	spaces_visible = not currently_on
--
-- 	spaces_indicator:set({
-- 		icon = spaces_visible and icons.switch.on or icons.switch.off,
-- 		drawing = true, -- Always show switch
-- 	})
--
-- 	-- Hide all spaces when showing menus, show spaces with apps when showing spaces
-- 	if spaces_visible then
-- 		-- Show spaces that have apps
-- 		for i = 1, TOTAL_SPACES do
-- 			if space_has_apps[i] then
-- 				spaces[i]:set({ drawing = true })
-- 			end
-- 		end
-- 	else
-- 		-- Hide all spaces when showing menus
-- 		for i = 1, TOTAL_SPACES do
-- 			spaces[i]:set({ drawing = false })
-- 		end
-- 	end
-- end)
--
-- -- Mouse hover events for spaces indicator are commented out
-- -- Only click trigger remains active
-- spaces_indicator:subscribe("mouse.clicked", function(env)
-- 	sbar.trigger("swap_menus_and_spaces")
-- end)
