local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

-- local LIST_ALL = "aerospace list-workspaces --all"
local LIST_CURRENT = "aerospace list-workspaces --focused"
local LIST_MONITORS = "aerospace list-monitors | awk '{print $1}'"
local LIST_WORKSPACES = "aerospace list-workspaces --monitor all --empty no"
local LIST_APPS = "aerospace list-windows --workspace %s | awk -F'|' '{gsub(/^ *| *$/, \"\", $2); print $2}'"
-- local LIST_APPS = "aerospace list-apps | awk -F'|' '{gsub(/^ +| +$/,\"\",$1); gsub(/^ +| +$/,\"\",$3); print $3}'"

local spaces = {}

local function getIconForApp(appName)
	return app_icons[appName] or "?"
end
-- local function execCommand(cmd)
-- 	local handle = io.popen(cmd)
-- 	if not handle then
-- 		return nil
-- 	end
-- 	local result = handle:read("*a")
-- 	handle:close()
-- 	return result
-- end
--
local function updateSpaceIcons(spaceId, workspaceName)
	local icon_strip = ""
	local shouldDraw = false

	sbar.exec(LIST_APPS:format(workspaceName), function(appsOutput)
		-- local appsOutput = execCommand(LIST_APPS:format(workspaceName))
		if not appsOutput then
			print("Warning: Failed to execute command for workspace: " .. workspaceName)
			return
		end
		local appFound = false

		for app in appsOutput:gmatch("[^\r\n]+") do
			local appName = app:match("^%s*(.-)%s*$") -- Trim whitespace
			if appName and appName ~= "" then
				icon_strip = icon_strip .. " " .. getIconForApp(appName)
				appFound = true
				shouldDraw = true
			end
		end

		if not appFound then
			icon_strip = " - "
			shouldDraw = true
		end

		if spaces[spaceId] then
			spaces[spaceId].item:set({
				label = { string = icon_strip, drawing = shouldDraw },
			})
		else
			print("Warning: Space ID '" .. spaceId .. "' not found when updating icons.")
		end
	end)
end

local function addWorkspaceItem(workspaceName, monitorId, isSelected)
	local spaceId = "workspace_" .. workspaceName

	if not spaces[spaceId] then
		local space_item = sbar.add("item", spaceId, {
			icon = {
				font = { family = settings.font.numbers },
				string = workspaceName,
			},
			label = {
				font = "sketchybar-app-font:Regular:25.0",
				y_offset = -3,
				padding_right = settings.paddings + 5,
			},
			blur_radius = 30,
			background = {
				padding_right = settings.paddings - 5,
				padding_left = settings.paddings - 5,
			},
			popup = {
				background = {
					border_width = 0,
					border_color = colors.border,
				},
				drawing = false,
			},
			click_script = "aerospace workspace " .. workspaceName,
			display = monitorId,
		})
		print(space_item.label)
		-- Create bracket for double border effect
		local space_bracket = sbar.add("bracket", { spaceId }, {
			-- background = {
			-- 	color = colors.with_alpha(colors.bar.bg, 0.5),
			-- 	border_color = colors.white,
			-- 	height = 28,
			-- 	border_width = 2,
			-- },
			drawing = true,
		})

		-- Subscribe to mouse events for changing workspace
		space_item:subscribe("mouse.clicked", function()
			sbar.exec("aerospace workspace " .. workspaceName)
		end)

		-- Store both the item and its bracket in the spaces table
		spaces[spaceId] = { item = space_item, bracket = space_bracket }
	end

	spaces[spaceId].item:set({
		icon = { highlight = isSelected },
		label = { highlight = isSelected },
	})

	spaces[spaceId].bracket:set({
		-- background = { border_color = isSelected and colors.dirty_white or colors.transparent },
		background = {
			color = colors.transparent,
			border_color = colors.border,
			height = 28,
			border_width = 0,
		},
	})
	-- local function space_item_position()
	-- 	-- local monitor = sbar.exec("aerospace list-monitors | awk -F'|' '{gsub(/^ +| +$/, "", $2); print $2}'")
	-- 	local monitor = sbar.exec("aerospace list-monitors --count")
	-- 	if monitor ~= "1" then
	-- 		spaces[spaceId].item:set({
	-- 			position = "left",
	-- 		})
	-- 	else
	-- 		spaces[spaceId].item:set({
	-- 			position = "center",
	-- 		})
	-- 	end
	-- end
	--
	-- space_item_position()

	updateSpaceIcons(spaceId, workspaceName)
end

local function drawSpaces()
	sbar.exec(LIST_MONITORS, function(monitorsOutput)
		-- Cache the focused workspace to avoid multiple `LIST_CURRENT` queries
		sbar.exec(LIST_CURRENT, function(focusedWorkspaceOutput)
			local focusedWorkspace = focusedWorkspaceOutput:match("[^\r\n]+")

			-- Iterate through monitors and workspaces
			for monitorId in monitorsOutput:gmatch("[^\r\n]+") do
				sbar.exec(LIST_WORKSPACES:format(monitorId), function(workspacesOutput)
					for workspaceName in workspacesOutput:gmatch("[^\r\n]+") do
						local isSelected = workspaceName == focusedWorkspace
						addWorkspaceItem(workspaceName, monitorId, isSelected)
					end
				end)
			end
		end)
	end)
end
-- local function execCommand(cmd)
-- 	local handle = io.popen(cmd)
-- 	if not handle then
-- 		return nil
-- 	end
-- 	local result = handle:read("*a")
-- 	handle:close()
-- 	return result
-- end
--
-- local function drawSpaces(draw)
-- 	if draw then
-- 		local monitorsOutput = execCommand(LIST_MONITORS)
-- 		if not monitorsOutput then
-- 			return
-- 		end
-- 		local focusedWorkspaceOutput = execCommand(LIST_CURRENT)
-- 		if not focusedWorkspaceOutput then
-- 			return
-- 		end
-- 		local focusedWorkspace = focusedWorkspaceOutput:match("[^\r\n]+")
-- 		for monitorId in monitorsOutput:gmatch("[^\r\n]+") do
-- 			local workspacesOutput = execCommand(LIST_WORKSPACES:format(monitorId))
-- 			if workspacesOutput then
-- 				for workspaceName in workspacesOutput:gmatch("[^\r\n]+") do
-- 					local isSelected = workspaceName == focusedWorkspace
-- 					addWorkspaceItem(workspaceName, monitorId, isSelected)
-- 				end
-- 			end
-- 		end
-- 	else
-- 		return
-- 	end
-- end

drawSpaces()

local space_window_observer = sbar.add("item", {
	drawing = false,
	updates = true,
})

local spaces_indicator = sbar.add("item", {
	padding_left = settings.paddings - 7,
	padding_right = settings.paddings - 10,
	icon = {
		string = icons.switch.on,
		padding_left = settings.paddings - 2,
		padding_right = settings.paddings - 1,
		color = colors.icon,
	},
	label = {
		string = "Spaces",
		width = 0,
		padding_left = settings.paddings - 10,
		padding_right = settings.paddings - 2,
		color = colors.label,
	},
	background = {
		color = colors.transparent,
		border_color = colors.bar,
		border_width = 0,
	},
})

space_window_observer:subscribe("aerospace_workspace_change", function(env)
	drawSpaces()
end)

space_window_observer:subscribe("front_app_switched", function()
	drawSpaces()
end)

space_window_observer:subscribe("space_windows_change", function()
	drawSpaces()
end)

spaces_indicator:subscribe("swap_menus_and_spaces", function(env)
	local currently_on = spaces_indicator:query().icon.value == icons.switch.on
	spaces_indicator:set({
		icon = currently_on and icons.switch.off or icons.switch.on,
	})
	drawSpaces()
end)

spaces_indicator:subscribe("mouse.entered", function(env)
	sbar.animate("tanh", 30, function()
		spaces_indicator:set({
			background = {
				color = colors.bar,
				border_color = { alpha = 1.0 },
			},
			icon = { color = colors.icon },
			label = { width = "dynamic", string = "Menu", color = colors.label },
		})
		drawSpaces()
	end)
end)

spaces_indicator:subscribe("mouse.exited", function(env)
	sbar.animate("tanh", 30, function()
		spaces_indicator:set({
			background = {
				color = { alpha = 0.0 },
				border_color = { alpha = 0.0 },
			},
			icon = { color = colors.icon },
			label = { width = 0 },
		})

		drawSpaces()
	end)
end)

spaces_indicator:subscribe("mouse.clicked", function(env)
	sbar.trigger("swap_menus_and_spaces")

	drawSpaces()
end)
