local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

-- Register custom events for calendar hover
sbar.add("event", "cal_hover_start")
sbar.add("event", "cal_hover_end")

-- Reference the existing widgets by their actual names from the other files
-- These widgets are already created in cpu.lua, memory.lua, sensors.lua etc.
local combined = sbar.add("alias", "Control Center,com.bjango.istatmenus.combined", {
	position = "right",
	background = {
		drawing = true,
	},
})
-- -- Function to hide all the existing widgets
-- local function hide_widgets()
-- 	sbar.animate("tanh", 30, function()
-- 		sbar.set(combined, {
-- 			drawing = false,
-- 		})
-- 	end)
-- end
--
-- -- Function to show all the existing widgets
-- local function show_widgets()
-- 	sbar.animate("tanh", 30, function()
-- 		sbar.set(combined, {
-- 			drawing = true,
-- 		})
-- 	end)
-- end
--
-- -- Subscribe to calendar hover events using a controller item
-- local widget_controller = sbar.add("item", "widget_controller", {
-- 	position = "right",
-- 	drawing = false, -- Hidden controller item
-- })
--
-- -- Subscribe to calendar events
-- combined:subscribe("cal_hover_start", show_widgets)
-- combined:subscribe("cal_hover_end", hide_widgets)
--
-- -- Initially hide all widgets when this loads
-- hide_widgets()
