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
			size = 18.0,
		},
		color = colors.icon,
		highlight_color = colors.icon_highlight,
		padding_left = settings.paddings,
		padding_right = settings.paddings,
		background = { image = { corner_radius = 9 } },
	},
	label = {
		font = {
			family = settings.font.text,
			style = settings.font.style_map["Semibold"],
			size = 16.0,
		},
		highlight_color = colors.label_highlight,
		color = colors.label_inactive,
		padding_left = settings.paddings - 2,
		padding_right = settings.paddings - 2,
	},
	background = {
		height = 40,
		corner_radius = 9,
		border_width = 1,
		color = colors.item,
		border_color = colors.item_border,
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
			border_color = colors.border,
			color = colors.bar,
			shadow = { drawing = true },
		},
	},
	scroll_texts = true,
})
