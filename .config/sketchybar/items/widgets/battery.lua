local colors = require("colors")
local settings = require("settings")
local icons = require("items.icon_map")

-- Helper: get battery icon based on percentage and state
local function get_battery_icon(percent, state)
	-- Round to nearest 10
	local rounded = math.floor((percent + 5) / 10) * 10
	if rounded > 100 then rounded = 100 end
	if rounded < 0 then rounded = 0 end

	local icon_name
	if state == "charging" then
		icon_name = "battery_charging_" .. rounded
	elseif state == "plugged" then
		icon_name = "battery_plugged_" .. rounded
	else
		icon_name = "battery_" .. rounded
	end

	return icons[icon_name] or icons["battery_0"]
end

-- BATTERY
local battery = sbar.add("item", "battery", {
	position = "right",
	update_freq = 10,
	icon = {
		string = icons["battery_100"],
		font = { family = "sketchybar-icon-font", style = "Regular", size = settings.iconL },
		color = colors.icon,
		padding_right = 4,
		y_offset = 6, -- Alignment fix
	},
	label = { string = "100%", font = { size = settings.fontXL }, color = colors.white },
	popup = {
		align = "right",
		height = 30,
		y_offset = 5,
		background = { color = colors.bar_solid, corner_radius = 8, border_width = 1, border_color = colors.border },
	},
})

local battery_popup = sbar.add("item", "battery.popup", {
	position = "popup." .. battery.name,
	icon = { drawing = false },
	label = { font = { size = settings.fontXL }, color = colors.white, padding_left = 12, padding_right = 12 },
})

battery:subscribe({ "routine", "forced", "system_woke", "power_source_change" }, function()
	sbar.exec("pmset -g batt", function(output)
		local percent = tonumber(output:match("(%d+)%%")) or 0
		local ac_connected = output:match("AC Power") ~= nil
		local charging = output:match("; charging;") ~= nil
		
		-- Determine State and Icon
		local state = "draining"
		if charging then
			state = "charging"
		elseif ac_connected then
			state = "plugged"
		end
		
		local icon_str = get_battery_icon(percent, state)
		
		-- Determine Color
		local icon_color = colors.icon -- Default white/grey
		
		if state == "charging" then
			icon_color = colors.green
		elseif state == "plugged" then
			icon_color = colors.blue -- Distinguish plugged-but-not-charging
		else
			-- Draining logic
			if percent < 10 then
				icon_color = colors.red
			elseif percent < 20 then
				icon_color = colors.yellow
			else
				icon_color = colors.white
			end
		end

		battery:set({
			icon = { string = icon_str, color = icon_color },
			label = { string = percent .. "%" },
		})
		
		local time_str = output:match("(%d+:%d+) remaining") or ""
		local watts = output:match("%(.*?(%d+%.?%d*) watts%)") or ""
		
		local popup_text = ""
		if charging then
			popup_text = "Charging: " .. time_str .. (watts ~= "" and " @ " .. watts .. "W" or "")
		elseif ac_connected then
			popup_text = "AC Connected (Not Charging)"
		else
			popup_text = "Time remaining: " .. (time_str ~= "" and time_str or "Calculating...")
		end
		
		battery_popup:set({ label = popup_text })
	end)
end)

battery:subscribe("mouse.entered", function()
	sbar.animate("tanh", 15, function()
		battery:set({ popup = { drawing = true } })
	end)
end)
battery:subscribe("mouse.exited", function()
	sbar.animate("tanh", 15, function()
		battery:set({ popup = { drawing = false } })
	end)
end)

return battery