local is_dark_mode = require("is_dark_mode") == "dark"

local colors = {}
local with_alpha = function(color, alpha)
	if alpha > 1.0 or alpha < 0.0 then
		return color
	end
	return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
end
colors.with_alpha = with_alpha

local theme = {
	-- black = 0xff181819,
	-- white = 0xffe2e2e3,
	red = 0xfffc5d7c,
	green = 0xff9ed072,
	blue = 0xff76cce0,
	yellow = 0xffe7c664,
	orange = 0xfff39660,
	magenta = 0xffb39df3,
	teal = 0xff1E5558,
	-- grey = 0xff7f8490,
	-- transparent = 0x00000000,
	-- teal = 0xFF51E1E9,
	purple = 0xffc952ed,
	dark = 0xff181818,
	dark_grey = 0xff282828,
	grey = 0xff383838,
	light_grey = 0xff585858,
	dark_silver = 0xffb8b8b8,
	silver = 0xffd8d8d8,
	light_silver = 0xffe8e8e8,
	light = 0xfff8f8f8,
	transparent = 0x00000000,
	black = 0xff000000,
	white = 0xffffffff,
	github_blue = 0xff4170ae,
}
for k, v in pairs(theme) do
	colors[k] = v
end

if is_dark_mode then
	colors.icon = theme.silver
	colors.icon_highlight = theme.blue
	colors.icon_secondary = theme.light
	colors.label = theme.light
	colors.label_inactive = with_alpha(theme.light, 0.5)
	colors.label_highlight = theme.green
	colors.label_secondary = theme.green
	colors.bar = with_alpha(theme.white, 0.01)
	colors.bar_light = with_alpha(theme.light, 0.01)
	colors.bar_solid = theme.dark
	colors.item = with_alpha(theme.grey, 0.5)
	colors.item_border = with_alpha(theme.dark, 0.5)
	colors.bracket = with_alpha(theme.light, 0.1)
	colors.border = theme.dark
	colors.active = theme.white
	colors.highlight = 0x40ffffff
	colors.highlight_text = 0xffffffff
else
	colors.icon = theme.black
	colors.icon_highlight = theme.blue
	colors.icon_secondary = theme.light_grey
	colors.label = theme.dark
	colors.label_inactive = with_alpha(theme.dark, 0.2)
	colors.label_highlight = theme.green
	colors.label_secondary = theme.black
	colors.bar = with_alpha(theme.light, 0.3)
	colors.bar_solid = theme.light
	colors.border = theme.silver
	colors.bracket = with_alpha(theme.dark, 0.1)
	colors.border = with_alpha(theme.light, 0.5)
	colors.item = with_alpha(theme.dark_grey, 0.2)
	colors.item_border = with_alpha(theme.dark, 0.5)
	colors.active = theme.white
end

return colors
