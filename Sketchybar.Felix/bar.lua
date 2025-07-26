local colors = require("colors")

-- sketchybar --add item left_anchor left --set left_anchor width=0 \
--            --add item q_anchor q --set q_anchor width=0 \
--            --add item e_anchor e --set e_anchor width=0 \
--            --add item right_anchor right --set right_anchor width=0 \
--            --add bracket left_bar left_anchor q_anchor \
--            --set left_bar background.color=0xff000000 \
--            --add bracket right_bar e_anchor right_anchor \
--            --set right_bar background.color=0xffffffff
-- Equivalent to the --bar domain

sbar.bar({
	height = 45,
	margin = 9,
	y_offset = -5,
	blur_radius = 20,
	corner_radius = 12,
	color = colors.with_alpha(colors.black, 0.0),
	padding_right = 20,
	padding_left = 20,
	border_color = colors.with_alpha(colors.teal, 0.3),
	border_width = 0,
	topmost = "window",
	sticky = "on",
	position = "top",
	notch_width = 300,
	display = "1,3",
})
