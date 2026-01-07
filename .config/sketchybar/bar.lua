local colors = require("colors")

-- Bar is transparent container - visual styling comes from brackets
sbar.bar({
	height = 36,
	margin = 0,
	y_offset = 4,
	blur_radius = 20,
	corner_radius = 0,
	color = colors.transparent,
	padding_right = 8,
	padding_left = 8,
	border_width = 0,
	topmost = "off",
	sticky = "on",
	position = "top",
	notch_width = 200,
	display = "all",
	shadow = {
		drawing = false,
	},
})
