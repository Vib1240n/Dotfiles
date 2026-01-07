local colors = require("colors")
local icons = require("icons")
local settings = require("settings")

-- Padding item required because of bracket
sbar.add("item", "left_padding", { width = 5 })

local apple = sbar.add("item", "apple", {
	icon = {
		font = { size = settings.iconL },
		string = icons.apple,
		padding_left = 8,
		padding_right = 0,
	},
	label = { drawing = false },
	background = {
		drawing = false,
	},
	click_script = "$CONFIG_DIR/helpers/menus/bin/menus -s 0",
})

return apple
