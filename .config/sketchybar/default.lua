local settings = require("settings")
local colors = require("colors")
-- paddings = 10,
-- 	group_paddings = 0,

-- Equivalent to the --default domain
sbar.default({
	updates = "when_shown",
	icon = {
		font = {
			family = settings.font.text,
			style = settings.font.style_map["Medium"],
			size = 16.0,
		},
		color = colors.bar.icon_light,
		padding_left = settings.paddings,
		padding_right = settings.paddings,
		background = { image = { corner_radius = 9 } },
	},
	label = {
		font = {
			family = settings.font.text,
			style = settings.font.style_map["Semibold"],
			size = 14.0,
		},
		color = colors.bar.label_dark,
		padding_left = settings.paddings - 2,
		padding_right = settings.paddings - 2,
	},
	background = {
		height = 30,
		corner_radius = 9,
		border_width = 0,
		color = colors.with_alpha(colors.bar.bg, 0.3),
		border_color = colors.with_alpha(colors.white, 0.5),
		-- border_color = colors.with_alpha(colors.white, 0.2),
		image = {
			corner_radius = 9,
			border_color = colors.grey,
			border_width = 0,
		},
	},
	popup = {
		topmost = true,
		blur_radius = 30,
		height = 50,
		-- padding_right = settings.paddings,
		-- padding_left = settings.paddings,
		background = {
			border_width = 2,
			corner_radius = 9,
			border_color = colors.white,
			color = colors.with_alpha(colors.bar.bg, 1),
			shadow = { drawing = true },
		},
	},
})
