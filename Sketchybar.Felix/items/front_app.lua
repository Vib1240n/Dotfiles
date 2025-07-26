local colors = require("colors")
local settings = require("settings")

local front_app = sbar.add("item", "front_app", {
	display = "active",
	blur_radius = 20,
	icon = {
		drawing = false,
		font = "sketchybar-app-font:Regular:18.0",
	},
	label = {
		font = {
			style = settings.font.style_map["Italic"],
			size = 14.0,
		},
		padding_right = 8,
		padding_left = 8,
	},
	background = {
		color = colors.with_alpha(colors.black, 0.3),
		padding_right = 7,
	},
	updates = true,
})

front_app:subscribe("front_app_switched", function(env)
	front_app:set({ icon = { string = env.INFO }, label = { string = env.INFO } })
end)

front_app:subscribe("mouse.clicked", function(env)
	sbar.trigger("swap_menus_and_spaces")
end)
