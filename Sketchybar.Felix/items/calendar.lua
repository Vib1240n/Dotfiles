local settings = require("settings")
local colors = require("colors")
-- local widgets = require("items.widgets")
-- Padding item required because of bracket
-- sbar.add("item", { position = "right", width = settings.group_paddings })

local cal = sbar.add("item", "cal", {
	icon = {
		color = colors.black,
		padding_left = 10,
		padding_right = 50,
		font = {
			style = settings.font.style_map["Regular"],
			size = 16.0,
		},
	},
	label = {
		color = colors.black,
		padding_right = 8,
		width = 55,
		align = "right",
		font = { family = settings.font.numbers, size = 16.0 },
	},
	position = "right",
	update_freq = 30,
	padding_left = 5,
	padding_right = -8,
	background = {
		color = colors.with_alpha(colors.black, 0.3),
		border_color = colors.with_alpha(colors.white, 0.5),
		border_width = 0,
	},
	-- click_script = "open -a 'Calendar'",
	-- click_script =
	-- 'osascript -e \'tell application "System Events" to tell process "Control Center" to perform action "AXPress" of menu bar item 1 of menu bar 1\'',
	popup = {
		topmost = true,
		blur_radius = 30,
		height = 50,
		padding_right = 10,
		padding_left = 10,
		align = "right",
		horizontal = true,
		background = {
			color = colors.with_alpha(colors.white, 0.01),
			border_width = 1,
			border_color = colors.with_alpha(colors.teal, 0.2),
			-- padding_right = 10,
			-- padding_left = 10,
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
sbar.add("item", { position = "right", width = settings.group_paddings })

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
	sbar.animate("sin", 3000, function(env)
		cal:set({ popup = { drawing = "toggle" } })
	end)
end)
