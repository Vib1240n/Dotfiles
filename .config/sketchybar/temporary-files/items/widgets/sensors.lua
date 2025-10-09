local colors = require("colors")
local settings = require("settings")

local sensors = sbar.add("alias", "Control Center,com.bjango.istatmenus.sensors", {
	position = "popup.cal",
	-- height = 30,
	-- padding_left = 0,
	-- background = {
	-- 	-- padding_right = 0,
	-- 	-- padding_left = 0,
	-- 	-- color = colors.bar.bg_dark,
	-- },
	-- icon = { drawing = false },
	-- label = { drawing = false },
	-- -- label = { padding_right = 0, padding_left = 0 },
	-- icon = { padding_right = 0, padding_left = 0 },
	-- width = 75,
	-- padding_right = 0,
})

sbar.add("bracket", "widgets.sensors.bracket", { sensors.name }, {
	-- padding_left = 0,
	background = { color = colors.transparent, border_width = 1, border_color = colors.white },
})

sbar.add("item", "widgets.sensors.padding", {
	position = "popup.cal",
	padding_right = 0,
	padding_left = 0,
	-- width = settings.group_paddings,
	icon = {
		padding_right = 0,
		padding_left = 0,
	},
	label = {
		padding_right = 0,
		padding_left = 0,
	},
	background = {
		padding_right = 0,
		padding_left = 0,
	},
	-- width = settings.group_paddings,
})
