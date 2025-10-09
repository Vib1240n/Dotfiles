local colors = require("colors")
local settings = require("settings")

local temp_widget = sbar.add("alias", "Control Center,Item-0", {
	position = "left",
	padding_left = settings.paddings,
	padding_right = settings.paddings,
	-- background = {
	-- 	drawing = false,
	-- },
	-- icon = { drawing = false },
	-- label = { drawing = false },
})

-- sbar.add("bracket", { temp_widget.name }, {
-- 	-- background = { color = colors.item },
-- 	-- padding_left = 10,
-- 	-- blur_radius = 30,
-- 	-- padding_right = 10,
-- })
