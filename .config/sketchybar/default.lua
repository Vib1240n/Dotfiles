local settings = require("settings")
local colors = require("colors")

sbar.default({
	updates = "when_shown",
	icon = {
		font = {
			family = settings.font.text,
			style = settings.font.style_map["Medium"],
			size = 14.0,
		},
		color = colors.icon,
		highlight_color = colors.purple,
		padding_left = 6,
		padding_right = 4,
		background = { image = { corner_radius = 6 } },
	},
	label = {
		font = {
			family = settings.font.text,
			style = settings.font.style_map["Semibold"],
			size = 13.0,
		},
		highlight_color = colors.purple,
		color = colors.label_inactive,
		padding_left = 4,
		padding_right = 6,
	},
	background = {
		height = 26,
		corner_radius = 6,
		border_width = 0,
		color = colors.transparent,
		border_color = colors.transparent,
		image = {
			corner_radius = 6,
			border_width = 0,
		},
	},
	popup = {
		topmost = true,
		blur_radius = 30,
		height = 40,
		background = {
			border_width = 1,
			corner_radius = 8,
			border_color = colors.border,
			color = colors.bar_solid,
			shadow = { drawing = true },
		},
	},
	scroll_texts = true,
})
