local colors = require("colors")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

local function getIconForApp(appName)
	return app_icons[appName] or "?"
end

local front_app = sbar.add("item", "front_app", {
	display = "active",
	blur_radius = 20,
	icon = {
		drawing = true,
		font = "sketchybar-app-font:Regular:18.0",
		y_offset = -1,
	},
	label = {
		font = {
			style = settings.font.style_map["SemiBold"],
			size = 18.0,
		},
		padding_left = settings.paddings - 15,
	},
	updates = true,
})

front_app:subscribe("front_app_switched", function(env)
	local set_icon = getIconForApp(env.INFO)
	front_app:set({ icon = { string = set_icon }, label = { string = env.INFO } })
end)

front_app:subscribe("mouse.clicked", function(env)
	sbar.trigger("swap_menus_and_spaces")
end)
