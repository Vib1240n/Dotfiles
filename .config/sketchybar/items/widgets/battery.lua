local colors = require("colors")
local settings = require("settings")

local battery = sbar.add("alias", "Control Center,com.bjango.istatmenus.battery", {
	position = "right",
	-- blur_radius = 30,
	-- height = 30,
	padding_left = settings.paddings,
	padding_right = settings.paddings,
	background = {
		drawing = false,
		-- color = colors.with_alpha(colors.black, 0.3),
		-- padding_right = 0,
		-- padding_left = 0,
		-- color = colors.bar.bg_dark,
	},
	icon = { drawing = false },
	label = { drawing = false },
	-- label = { padding_right = 0, padding_left = 0 },
	-- icon = { padding_right = 0, padding_left = 0 },
	-- width = 75,
	-- padding_right = 0,
})

-- sbar.set({ battery.name }, {
-- 	alias = { scale = 1.0 },
-- })
-- local remaining_time = sbar.add("item", {
-- 	position = "popup." .. battery.name,
-- 	icon = {
-- 		string = "Time remaining:",
-- 		width = 100,
-- 		align = "left",
-- 	},
-- 	label = {
-- 		string = "??:??h",
-- 		width = 100,
-- 		align = "right",
-- 	},
-- })

sbar.add("bracket", { battery.name }, {
	background = { color = colors.with_alpha(colors.bar.bg, 0.3) },
	-- padding_left = 10,
	blur_radius = 30,
	-- padding_right = 10,
})

-- battery_bracket:subscribe("mouse.entered", function(env)
-- 	sbar.animate("tanh", 30, function()
-- 		battery.set({
-- 			popup = {
-- 				drawing = "toggle",
-- 			},
-- 		})
-- 	end)
-- end)
-- sbar.add("item", "widgets.battery.padding", {
-- 	position = "right",
-- 	width = settings.group_paddings,
-- })
