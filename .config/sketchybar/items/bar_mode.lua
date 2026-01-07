local colors = require("colors")
local settings = require("settings")

local bar_mode = "split"

local left_bracket = sbar.add("bracket", {
	"left_padding",
	"apple",
	"front_app",
	"/space\\..*/",
	"spaces_indicator",
}, {
	background = {
		color = colors.bar_light,
		height = settings.split_height - 24,
		corner_radius = settings.bracket_cr,
		border_width = 2,
		-- border_color = colors.light,
		--
		border_color = colors.with_alpha(colors.black, 0.9),
	},
	border_width = 1,
	border_color = colors.transparent,
	padding_left = settings.paddings + 10,
	blur_radius = 8,
	padding_right = settings.paddings,
})

local right_bracket = sbar.add("bracket", {
	"stats.toggle",
	"battery",
	"cpu",
	"gpu",
	"ram",
	"network",
	"disk",
	"bar_toggle",
	"widgets.bitwarden",
	"cal",
	"right_padding",
}, {
	background = {
		border_width = 2,
		border_color = colors.with_alpha(colors.black, 0.9),

		color = colors.bar_light,
		height = settings.split_height - 24,
		corner_radius = settings.bracket_cr,
	},

	blur_radius = 20,
})

-- local function set_split_mode()
-- 	bar_mode = "split"
-- 	sbar.set("bar_toggle", { icon = { string = "􀨤" } })
--
-- 	sbar.bar({
-- 		color = colors.transparent,
-- 		margin = 0,
-- 		padding_left = 8,
-- 		padding_right = 8,
-- 	})
-- 	left_bracket:set({
-- 		background = {
-- 			color = colors.transparent,
-- 			blur_radius = 5,
-- 			corner_radius = 8,
-- 			height = settings.split_height,
-- 			border_width = 0,
-- 			border_color = colors.border,
-- 		},
-- 	})
-- 	right_bracket:set({
-- 		background = {
-- 			color = colors.bar_solid,
-- 			corner_radius = 8,
-- 			height = settings.split_height,
-- 		},
-- 	})
-- end
--
-- local function set_full_mode()
-- 	bar_mode = "full"
-- 	sbar.set("bar_toggle", { icon = { string = "􀨥" } })
--
-- 	sbar.bar({
-- 		color = colors.bar_solid,
-- 		margin = 6,
-- 		padding_left = 4,
-- 		padding_right = 4,
-- 		corner_radius = 10,
-- 	})
-- 	left_bracket:set({ background = { color = colors.transparent } })
-- 	right_bracket:set({ background = { color = colors.transparent } })
-- end
--
local function skhd_mode_handler(border_color, border_width)
	left_bracket:set({
		background = {
			-- color = colors.bar_solid,
			-- height = settings.split_height,
			-- corner_radius = 8,
			border_width = border_width,
			border_color = border_color,
		},
	})
end
--
-- local function toggle_bar_mode()
-- 	if bar_mode == "split" then
-- 		set_full_mode()
-- 	else
-- 		set_split_mode()
-- 	end
-- end
--
-- sbar.add("item", "bar_mode_handler", {
-- 	drawing = false,
-- }):subscribe("bar_toggle_clicked", toggle_bar_mode)
--
-- sbar.add("event", "bar_toggle_clicked")
sbar.add("event", "mode_change")

left_bracket:subscribe("mode_change", function(env)
	print("=== MODE CHANGE ===")
	print("MODE:", env.MODE)

	local mode = env.MODE or "default"

	local border_color_map = {
		default = colors.with_alpha(colors.light, 0.5),
		resize = colors.purple,
		service = colors.orange,
		open = colors.red,
		pass = colors.green,
	}

	local border_color = border_color_map[mode] or colors.magenta
	local border_width = (mode == "default") and 1 or 2

	-- print("Border width:", border_width)

	skhd_mode_handler(border_color, border_width)
end)
--
-- set_split_mode()

return { left_bracket = left_bracket, right_bracket = right_bracket }
