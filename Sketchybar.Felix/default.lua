local settings = require("settings")
local colors = require("colors")

-- Equivalent to the --default domain
sbar.default({
	updates = "when_shown",
	icon = {
		font = {
			family = settings.font.text,
			style = settings.font.style_map["Medium"],
			size = 16.0,
		},
		color = colors.black,
		-- padding_left = settings.paddings,
		-- padding_right = settings.paddings,
		background = { image = { corner_radius = 9 } },
	},
	label = {
		font = {
			family = settings.font.text,
			style = settings.font.style_map["Semibold"],
			size = 14.0,
		},
		color = colors.bar.icon_light,
		-- padding_left = settings.paddings,
		-- padding_right = settings.paddings,
	},
	background = {
		height = 30,
		corner_radius = 9,
		border_width = 0,
		-- border_color = colors.with_alpha(colors.white, 0.2),
		-- image = {
		-- 	corner_radius = 9,
		-- 	border_color = colors.grey,
		-- 	border_width = 0,
		-- },
	},
	popup = {
		background = {
			border_width = 2,
			corner_radius = 9,
			border_color = colors.popup.border,
			color = colors.popup.transparent,
			shadow = { drawing = true },
		},
		blur_radius = 50,
	},
	-- padding_left = 3,
	-- padding_right = 3,
	scroll_texts = true,
})
