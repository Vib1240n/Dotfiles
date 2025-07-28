local settings = require("settings")
local colors = require("colors")

local cal = sbar.add("item", "cal", {
	icon = {
		font = {
			style = settings.font.style_map["Regular"],
			size = 16.0,
		},
	},
	position = "right",
	label = {
		font = {
			size = 16.0,
		},
		color = colors.white,
	},
	padding_left = settings.paddings - 5,
	update_freq = 30,
	popup = {
		align = "right",
		horizontal = false,
		background = {
			color = colors.with_alpha(colors.black, settings.alpha - 0.5),
			border_color = colors.with_alpha(colors.teal, 0.2),
		},
	},
})

-- local widget_sensor = sbar.add("alias", "Control Center,com.bjango.istatmenus.sensors", {
-- 	position = cal.popup,
-- })
--
-- widget_sensor:set({ position = cal.popup })
-- -- Double border for calendar using a single item bracket
-- sbar.add("bracket", { cal.name }, {
-- 	background = {
-- 		color = colors.transparent,
-- 		height = 30,
-- 	},
-- })

-- Padding item required because of bracket
-- sbar.add("item", { position = "right", width = settings.group_paddings })

cal:subscribe({ "forced", "routine", "system_woke" }, function(env)
	cal:set({ icon = os.date("%a, %d %b %Y,"), label = os.date("%I:%M %p") })
end)

local function show_popup()
	cal:set({ popup = { drawing = true } })
end

local function hide_popup()
	cal:set({ popup = { drawing = false } })
end
local function toggle_popup()
	cal:set({ popup = { drawing = "toggle" } })
end
-- cal:subscribe("mouse.exited", function(env)
-- 	sbar.animate("tanh", 10, function()
-- 		hide_popup()
-- 	end)
-- end)
--
-- cal:subscribe("mouse.entered", function(env)
-- 	sbar.animate("sin", 30, function()
-- 		cal:set({ popup = { drawing = true } })
-- 	end)
-- end)
cal:subscribe("mouse.clicked", function(env)
	sbar.animate("tanh", 30, function(env)
		cal:set({ popup = { drawing = "toggle" } })
	end)
end)
