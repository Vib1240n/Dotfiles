local colors = require("colors")
local settings = require("settings")

sbar.add("event", "show_battery")
local battery = sbar.add("alias", "Control Center,com.bjango.istatmenus.battery", {
	position = "right",
	icon = { drawing = false },
	label = { drawing = false },
	background = { drawing = false },
	-- padding_left = settings.paddings,
	-- padding_right = settings.paddings,
	drawing = false,
})

-- sbar.animate("tanh", "30", function()
battery:subscribe("show_battery", function()
	battery.set({
		drawing = "toggle",
	})
end)
-- end)
-- sbar.add("bracket", "battery_bracket", { battery.name }, {
-- 	drawing = false,
-- 	background = { color = colors.transparent, border_width = 1, border_color = colors.white },
-- })
