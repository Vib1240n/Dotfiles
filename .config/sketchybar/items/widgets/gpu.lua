local colors = require("colors")
local settings = require("settings")

-- GPU
local gpu = sbar.add("item", "gpu", {
	position = "right",
	update_freq = 5,
	icon = { string = "􀫥", font = { size = settings.fontL }, color = colors.blue, padding_right = 4 },
	label = { string = "0%", font = { size = settings.fontL }, color = colors.white, padding_right = 6 },
})

-- GPU update using powermetrics
gpu:subscribe({ "routine", "forced" }, function()
	sbar.exec(
		"sudo powermetrics -n 1 -i 100 --samplers gpu_power 2>/dev/null | grep 'GPU HW active residency' | head -1",
		function(output)
			local pct = output:match("residency:%s+(%d+%.?%d*)%%")
			if pct then
				gpu:set({ label = math.floor(tonumber(pct)) .. "%" })
			else
				gpu:set({ label = "N/A" })
			end
		end
	)
end)

gpu:subscribe("mouse.clicked", function()
	sbar.exec("open -na kitty --args btop")
end)

return gpu
