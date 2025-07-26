local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

function parse_string_to_table(s)
	local result = {}
	for line in s:gmatch("([^\n]+)") do
		table.insert(result, line)
	end
	return result
end

local file = io.popen("aerospace list-workspaces --empty no --monitor all")
local result = file:read("*a")
file:close()
local active_workspace = io.popen("aerospace list-workspaces --focused")
local workspace_active = active_workspace:read("*a")
active_workspace:close()

local workspaces = parse_string_to_table(result)
for i, workspace in ipairs(workspaces) do
	local space = sbar.add("item", "space." .. workspace, {
		-- space = i,
		icon = {
			-- string = workspace,
			-- color = colors.white,
			-- highlight_color = colors.red,
			font = { family = settings.font.numbers },
			string = workspace,
			padding_left = 5,
			padding_right = 5,
			color = colors.white,
			highlight_color = colors.green,
		},
		label = {
			drawing = false,
			padding_right = 5,
			color = colors.white,
			highlight_color = colors.red,
			font = "sketchybar-app-font:Regular:16.0",
			y_offset = 0,
			highlight_color = colors.green,
		},
		padding_right = 1,
		padding_left = 1,
		background = {
			drawing = false,
			color = colors.bar.bg_dark,
			border_width = 0,
			height = 28,
			border_color = colors.black,
			blur_radius = 20,
			-- highlight_color = colors.green,

			-- padding_left = 10,
			-- padding_right = 1,
		},

		-- popup = { background = { border_width = 5, border_color = colors.black } },
	})

	local space_bracket = sbar.add("bracket", { space.name }, {
		background = {
			color = colors.transparent,
			border_color = colors.bg2,
			height = 25,
			border_width = 0,
		},
	})
	sbar.add("space", "space.padding." .. i, {
		space = i,
		script = "",
		width = settings.group_paddings,
	})
	local space_popup = sbar.add("item", {
		position = "popup." .. space.name,
		padding_left = 5,
		padding_right = 5,
		background = {
			drawing = true,
			image = {
				corner_radius = 9,
				scale = 0.2,
			},
		},
	})
	space:subscribe("aerospace_focus_change", function(env)
		local selected = env.FOCUSED_WORKSPACE == workspace
		space:set({
			icon = { highlight = selected },
			label = { highlight = selected },
			background = { border_color = selected and colors.white or colors.bg2 },
		})
		space_bracket:set({
			background = { border_color = selected and colors.grey or colors.bg2 },
		})
	end)
	-- space:subscribe("mouse.clicked", function(env)
	-- 	if env.BUTTON == "other" then
	-- 		space_popup:set({ background = { image = "space." .. env.SID } })
	-- 		space:set({ popup = { drawing = "toggle" } })
	-- 	else
	-- 		local op = (env.BUTTON == "right") and "--destroy" or "--focus"
	-- 		sbar.exec("yabai -m space " .. op .. " " .. env.SID)
	-- 	end
	-- end)
	-- space:subscribe("mouse.exited", function(_)
	-- 	space:set({ popup = { drawing = false } })
	-- end)
end
local space_window_observer = sbar.add("item", {
	drawing = false,
	updates = true,
	background = {
		color = colors.red,
	},
})
local spaces_indicator = sbar.add("item", {
	padding_left = 2,
	padding_right = 5,
	icon = {
		padding_left = 5,
		padding_right = 5,
		color = colors.bar.white,
		string = icons.switch.off,
		font = settings.font.text["SemiBold"],
	},
	label = {
		width = 0,
		padding_left = 0,
		padding_right = 8,
		string = "Spaces",
		color = colors.bar.bg_light,
		font = settings.font.text["SemiBold"],
	},
	background = {
		-- color = colors.bar.bg_light,
		border_width = 0,
	},
})
space_window_observer:subscribe("aerospace_focus_change", function()
	sbar.exec("aerospace list-windows --workspace focused --format '%{app-name}' --json ", function(apps)
		local icon_line = ""
		local no_app = true
		for i, app in ipairs(apps) do
			no_app = false
			local app_name = app["app-name"]
			local lookup = app_icons[app_name]
			local icon = ((lookup == nil) and app_icons["default"] or lookup)
			icon_line = icon_line .. " " .. icon
		end

		if no_app then
			icon_line = " —"
		end

		sbar.animate("tanh", 10, function()
			workspace:set({ label = icon_line })
		end)
	end)
end)
-- space_window_observer:subscribe("aerospace_workspace_change", function(env)
-- 	local icon_line = ""
-- 	local no_app = true
-- 	for app, count in pairs(env.INFO.apps) do
-- 		no_app = false
-- 		local lookup = app_icons[app]
-- 		local icon = ((lookup == nil) and app_icons["Default"] or lookup)
-- 		icon_line = icon_line .. icon
-- 	end
-- space_window_observer:subscribe("aerospace_focus_change", function(env)
-- 	local selected = env.FOCUSED_WORKSPACE == workspace
-- 	space:set({
-- 		icon = { highlight = selected },
-- 		label = { highlight = selected },
-- 		background = { border_color = selected and colors.white or colors.bg2 },
-- 	})
-- end)
-- end

-- if no_app then
-- 	icon_line = " —"
-- end
-- sbar.animate("tanh", 10, function()
-- 	spaces[env.INFO.space]:set({ label = icon_line })
-- end)
-- end)

spaces_indicator:subscribe("swap_menus_and_spaces", function(env)
	local currently_on = spaces_indicator:query().icon.value == icons.switch.on
	spaces_indicator:set({
		icon = currently_on and icons.switch.off or icons.switch.on,
	})
end)

spaces_indicator:subscribe("mouse.entered.global", function(env)
	sbar.animate("tanh", 30, function()
		spaces_indicator:set({
			background = {
				color = { alpha = 1.0 },
				border_color = { alpha = 1.0 },
			},
			icon = { color = colors.bar.label_white },
			label = { width = "dynamic", color = colors.red },
		})
	end)
end)

spaces_indicator:subscribe("mouse.exited.global", function(env)
	sbar.animate("tanh", 30, function()
		spaces_indicator:set({
			background = {
				color = { alpha = 0.0 },
				border_color = { alpha = 0.0 },
			},
			icon = { color = colors.grey },
			label = { width = 0 },
		})
	end)
end)

spaces_indicator:subscribe("mouse.entered", function(env)
	sbar.trigger("swap_menus_and_spaces")
end)
