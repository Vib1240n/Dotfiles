local colors = require("colors")
local icons = require("icons")
local settings = require("settings")

-- Padding item required because of bracket
sbar.add("item", { width = 0 })

local apple = sbar.add("item", {
	icon = {
		font = { size = 26.0 },
		string = icons.apple,
		y_offset = 2,
	},
	label = { drawing = false },
	background = {
		drawing = false,
	},
	click_script = "$CONFIG_DIR/helpers/menus/bin/menus -s 0",
})

-- Double border for apple using a single item bracket
sbar.add("bracket", { apple.name }, {
	padding_left = settings.paddings,
	padding_right = settings.paddings,
	background = {
		drawing = true,
		color = colors.transparent,
		height = 30,
		border_color = colors.border,
		border_width = 0,
	},
})

-- Padding item required because of bracket
-- sbar.add("item", { width = 7 })
