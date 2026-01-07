local colors = require("colors")
local settings = require("settings")

sbar.add("event", "fan_speed")

-- FAN (only shows when > 2500 RPM)
local fan = sbar.add("item", "fan", {
	position = "right",
	update_freq = 1,
	icon = { string = "􀇥", font = { size = settings.fontL }, color = colors.orange, padding_right = 4 },
	label = { string = "0", font = { size = settings.fontL }, color = colors.white, padding_right = 6 },
	drawing = false, -- Hidden by default
})

-- Fan speed monitoring (runs independently)
-- Fan speed monitoring - piggyback on system_stats updates
-- Fan speed monitoring with debug output
fan:subscribe("fan_speed", function()
	print("=== FAN SUBSCRIPTION TRIGGERED ===")
	sbar.exec("/Applications/Stats.app/Contents/Resources/smc fans", function(fan_output)
		print("Fan output received: " .. (fan_output or "nil"))
		local fan0_speed = fan_output:match("0: Fan #0.-Actual speed: ([%d%.%-]+)")
		local fan1_speed = fan_output:match("1: Fan #1.-Actual speed: ([%d%.%-]+)")

		print("Fan0: " .. tostring(fan0_speed) .. ", Fan1: " .. tostring(fan1_speed))

		local fan0 = tonumber(fan0_speed)
		local fan1 = tonumber(fan1_speed)

		local max_fan = math.max(fan0 or 0, fan1 or 0)

		print("Max fan: " .. tostring(max_fan))

		if max_fan > 2500 then
			print("Setting fan visible with RPM: " .. max_fan)
			fan:set({
				drawing = true,
				label = string.format("%.0f", max_fan),
			})
		else
			print("Hiding fan, RPM below threshold")
			fan:set({ drawing = false })
		end
	end)
end)
fan:subscribe("mouse.clicked", function()
	sbar.exec("open -a Stats")
end)

return fan
