local colors = require("colors")
local settings = require("settings")
-- local widgets = require("items.widgets")
local icons = require("icons")
local popup_width = 500

sbar.add("event", "widgets_popup_show")
local widgets_popup = sbar.add("item", "widgets_items", {
	position = "right",
	drawing = false,
	icons = {
		font = { size = 24.0 },
		string = icons.switch_on,
		padding_right = 0,
		padding_left = -2,
		y_offset = 2,
	},
	label = {
		drawing = false,
		string = icons.switch_on,
		color = colors.white,
		background = colors.black,
		padding_left = 3,
		padding_right = 3,
	},

	-- label = {
	-- 	font = {
	-- 		style = settings.font.style_map["Black"],
	-- 		size = 14.0,
	-- 	},
	-- 	padding_right = 8,
	-- 	padding_left = 8,
	-- 	drawing = false,
	-- },
	background = {
		color = colors.transparent,
		border_color = colors.black,
		border_width = 0,
	},
	padding_left = 1,
	padding_right = 1,
	-- updates = true,
})
local widgets_bracket = sbar.add("bracket", "widgets.e.bracket", {
	widgets_popup.name,
}, {
	background = { color = colors.with_alpha(colors.white, 0.2) },
	popup = { align = "center" },
	border_width = 0,
	margin = 5,
})
sbar.add("item", "widgets.e.padding", {
	position = "right",
	width = 10,
})

-- local widgets_menu = sbar.add("item", popup_width, {
-- 	position = "popup." .. widgets_bracket.name,
-- 	item = {
-- 		highlight_color = colors.blue,
-- 		background = {
-- 			height = 6,
-- 			corner_radius = 3,
-- 			color = colors.bg2,
-- 		},
-- 	},
--
-- 	background = { color = colors.bg1, height = 2, y_offset = -20 },
-- })
-- sbar.add("bracket", {
-- 	widgets,
-- }, {
-- 	background = { color = colors.white },
-- 	popup = { alight = "center" },
-- 	border_width = 0,
-- 	margin = 5,
-- })
--

-- widgets_popup:subscribe("mouse.entered", function(env)
-- 	widgets_popup:set({ drawing = true })
-- end)
--
-- widgets_popup:subscribe("mouse.exited", function(env)
-- 	widgets_popup:set({ drawing = false })
-- end)
--
