local colors = require("colors")
local alpha_value = 0.3 -- Glassmorphic alpha for bar background

sbar.bar({
	height = 55,
	margin = 9,
	y_offset = 5,
	blur_radius = 20,
	corner_radius = 12,
	color = colors.bar, -- Already has 0.3 alpha glassmorphic effect
	padding_right = 5,
	padding_left = 0,
	border_color = colors.border, -- No traditional border
	border_width = 1, -- Using shadow as border instead
	topmost = "off",
	sticky = "on",
	position = "top",
	notch_width = 300,
	display = "all",
	shadow = {
		drawing = true,
		color = colors.border, -- Default shadow color
		angle = 270, -- Shadow below the bar
		distance = 3, -- How far the shadow extends
	},
})

-- Add a dummy item to handle mode changes
sbar.add("item", "mode_handler", {
	position = "left",
	width = 0,
})

sbar.subscribe("mode_handler", "mode_change", function(env)
	local mode = env.MODE or "main"

	local color_map = {
		default = colors.bar,
		resize = colors.purple,
		service = colors.orange,
		open = colors.red,
		pass = colors.green,
	}
	local border_color_map = {
		default = colors.border,
		resize = colors.purple,
		service = colors.orange,
		open = colors.red,
		pass = colors.green,
	}
	local mode_color = color_map[mode] or colors.magenta
	local border_color = border_color_map[mode] or colors.magenta

	-- Update bar background with mode color at 0.3 alpha for glassmorphic effect
	-- Update shadow with mode color for glowing border effect
	sbar.bar({
		color = colors.with_alpha(mode_color, alpha_value),
		border_color = border_color,
		shadow = {
			color = mode_color, -- Full opacity for visible glow
		},
	})
end)
