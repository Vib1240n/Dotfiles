local colors = require("colors")
local settings = require("settings")

-- Bar mode toggle
local bar_toggle = sbar.add("item", "bar_toggle", {
	position = "right",
	icon = {
		string = "􀨤",
		font = { family = settings.font.text, style = settings.font.style_map["Regular"], size = settings.fontL },
		color = colors.icon,
		padding_left = 6,
	},
	label = { drawing = false },
	background = { drawing = false },
})

bar_toggle:subscribe("mouse.entered", function()
	bar_toggle:set({ icon = { color = colors.white } })
end)
bar_toggle:subscribe("mouse.exited", function()
	bar_toggle:set({ icon = { color = colors.icon } })
end)
bar_toggle:subscribe("mouse.clicked", function()
	sbar.trigger("bar_toggle_clicked")
end)

return bar_toggle
