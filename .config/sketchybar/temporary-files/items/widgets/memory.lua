local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local memory = sbar.add("alias", "Control Center,com.bjango.istatmenus.memory", {
	position = "popup.cal",
	padding_right = 0,
	padding_left = 0,

	-- height = 30,
	-- padding_left = 0,
	-- background = {
	-- 	-- padding_right = 0,
	-- 	-- padding_left = 0,
	-- 	-- color = colors.bar.bg_dark,
	-- },
	-- icon = { drawing = false },
	-- label = { drawing = false },
	-- label = { padding_right = 0, padding_left = 0 },
	-- icon = { padding_right = 0, padding_left = 0 },
	-- width = 75,
	-- padding_right = 0,
})

sbar.add("bracket", "widgets.memory.bracket", { memory.name }, {
	background = { color = colors.transparent },
	padding_right = 0,
	padding_left = 0,
})

sbar.add("item", "widgets.memory.padding", {
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
