local colors = require("colors")
local settings = require("settings")

-- NETWORK
local network = sbar.add("item", "network", {
	position = "right",
	update_freq = 10,
	icon = { string = "􀙇", font = { size = settings.fontL }, color = colors.icon, padding_right = 4 },
	label = { string = "WiFi", font = { size = settings.fontL }, color = colors.white, padding_right = 6 },
	popup = {
		align = "right",
		height = 30,
		y_offset = 5,
		background = { color = colors.bar_solid, corner_radius = 8, border_width = 1, border_color = colors.border },
	},
})

local network_popup = sbar.add("item", "network.popup", {
	position = "popup." .. network.name,
	icon = { drawing = false },
	label = { font = { size = settings.fontXL }, color = colors.white, padding_left = 12, padding_right = 12 },
})

-- Network update
network:subscribe({ "routine", "forced", "wifi_change" }, function()
	sbar.exec("ipconfig getsummary en0 2>/dev/null | awk -F': ' '/^  SSID/ {print $2}'", function(output)
		local ssid = output:gsub("%s+$", "")
		if ssid ~= "" and ssid ~= "<redacted>" then
			network:set({ icon = { string = "􀙇" }, label = ssid })
		elseif ssid == "<redacted>" then
			network:set({ icon = { string = "􀙇" }, label = "WiFi" })
		else
			sbar.exec("ifconfig en0 2>/dev/null | grep 'inet '", function(inet)
				if inet:match("inet") then
					network:set({ icon = { string = "􀤆" }, label = "Ethernet" })
				else
					network:set({ icon = { string = "􀙈" }, label = "No Network" })
				end
			end)
		end
	end)
end)

network:subscribe("mouse.entered", function()
	sbar.exec(
		"networksetup -getairportnetwork en0 && system_profiler SPAirPortDataType 2>/dev/null | grep -A2 'PHY Mode'",
		function(output)
			local rate = output:match("Transmit Rate: (%d+)") or output:match("maxRate: (%d+)")
			network_popup:set({ label = rate and ("Speed: " .. rate .. " Mbps") or "Speed: N/A" })
		end
	)
	sbar.animate("tanh", 15, function()
		network:set({ popup = { drawing = true } })
	end)
end)
network:subscribe("mouse.exited", function()
	sbar.animate("tanh", 15, function()
		network:set({ popup = { drawing = false } })
	end)
end)
network:subscribe("mouse.clicked", function()
	sbar.exec("open 'x-apple.systempreferences:com.apple.preference.network?Wi-Fi'")
end)

return network
