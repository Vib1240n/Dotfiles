local settings = require("settings")
local colors = require("colors")

local cal = sbar.add("item", "cal", {
	position = "right",
	icon = { drawing = false },
	label = {
		font = { size = 16.0 },
		color = colors.white,
		padding_left = 8,
		padding_right = 8,
	},
	background = { drawing = false },
	update_freq = 30,
	popup = {
		align = "right",
		height = 30,
		y_offset = 5,
		background = {
			color = colors.bar_solid,
			corner_radius = 8,
			border_width = 1,
			border_color = colors.border,
		},
	},
})

local cal_popup = sbar.add("item", "cal.popup", {
	position = "popup." .. cal.name,
	icon = { drawing = true },
	label = {
		font = { size = 16.0 },
		color = colors.white,
		padding_left = 12,
		padding_right = 12,
	},
})

sbar.add("item", "right_padding", { position = "right", width = 5 })

cal:subscribe({ "forced", "routine", "system_woke" }, function()
	cal:set({ label = os.date("%I:%M %p") })
	cal_popup:set({ label = os.date("%A, %B %d, %Y  -  %I:%M:%S %p") })
end)

cal:subscribe("mouse.entered", function()
	cal_popup:set({ label = os.date("%A, %B %d, %Y  -  %I:%M:%S %p") })
	sbar.animate("tanh", 25, function()
		cal:set({ popup = { drawing = true } })
	end)
end)

cal:subscribe("mouse.exited", function()
	sbar.animate("tanh", 25, function()
		cal:set({ popup = { drawing = false } })
	end)
end)

cal:subscribe("mouse.clicked", function()
	sbar.exec("open -a Calendar")
end)

return cal
