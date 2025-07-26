local colors = require("colors")
local settings = require("settings")
local icons = require("icons")

local LIST_MODE = "aerospace list-modes --current"
local alpha_value = 1
-- local LIST_ALL_MODES = "aerospace list-modes"

local mode_item = sbar.add("item", {
	position = "left",
	icon = {
		font = {
			size = 20,
		},
		y_offset = 1,
	},
	label = {
		drawing = false,
	},
	background = {
		drawing = false,
	},
	-- blur_radius = 30,
	-- drawing = true,
	-- popup = {
	--   topmost = true,
	--   blur_radius = 30,
	--   height = 50,
	--   padding_right = 10,
	--   padding_left = 10,
	--   align = "right",
	--   horizontal = true,
	--   background = {
	--     color = colors.with_alpha(colors.white, 0.01),
	--     border_width = 1,
	--     border_color = colors.with_alpha(colors.teal, 0.2),
	--     -- padding_right = 10, -- padding_left = 10, }, },
})
local function mode_icon(mode)
	local set_icon = "? ?"
	if string.find(mode, "service") then
		set_icon = icons.gear
	elseif string.find(mode, "open") then
		set_icon = icons.open
	elseif string.find(mode, "resize") then
		set_icon = icons.resize
	elseif string.find(mode, "pass") then
		set_icon = icons.lock
	elseif string.find(mode, "main") then
		set_icon = icons.main
	else
		set_icon = "??"
	end
	return set_icon
end

-- Create bracket for double border effect
-- local mode_bracket = sbar.add("bracket", { mode_item.name }, {
-- 	background = {
-- 		-- color = colors.with_alpha(colors.black, 0.3),
-- 		border_color = colors.white,
-- 		height = 30,
-- 		border_width = 0,
-- 		padding_right = 15,
-- 		padding_left = 15,
-- 	},
-- 	-- padding_right = 15,
-- 	-- padding_left = 15,
-- 	blur_radius = 30,
-- 	-- drawing = true,
-- })

mode_item:subscribe("space_windows_change", function()
	local function execCommand(cmd)
		local handle = io.popen(cmd)
		if not handle then
			return nil
		end
		local result = handle:read("*a")
		handle:close()
		return result
	end

	local modeOutput = execCommand(LIST_MODE)
	if modeOutput then
		modeOutput = modeOutput:gsub("%s+$", "") -- trim trailing spaces/newlines
		modeOutput = modeOutput:lower()
		local set_mode_icon = mode_icon(modeOutput)
		mode_item:set({
			label = {
				string = modeOutput,
			},
			icon = {
				string = set_mode_icon,
			},
		})
		if string.find(modeOutput, "main") then
			mode_item:set({ icon = { color = colors.with_alpha(colors.bar.icon_dark, alpha_value) } })
		elseif string.find(modeOutput, "resize") then
			mode_item:set({ icon = { color = colors.with_alpha(colors.purple, alpha_value) } })
		elseif string.find(modeOutput, "service") then
			mode_item:set({ icon = { color = colors.with_alpha(colors.orange, alpha_value) } })
		elseif string.find(modeOutput, "open") then
			mode_item:set({ icon = { color = colors.with_alpha(colors.red, alpha_value) } })
		elseif string.find(modeOutput, "pass") then
			mode_item:set({ icon = { color = colors.with_alpha(colors.green, alpha_value) } })
		else
			mode_item:set({ icon = { color = colors.with_alpha(colors.magenta, alpha_value) } })
		end
	end
end)

-- mode_item:subscribe("space_windows_change", function()
-- 	sbar.exec(LIST_MODE, function(modeOutput)
-- 		modeOutput = modeOutput:gsub("%s+$", "") -- trim trailing spaces/newlines
-- 		modeOutput = modeOutput:lower()
-- 		local set_mode_icon = mode_icon(modeOutput)
-- 		mode_item:set({
-- 			label = {
-- 				string = modeOutput,
-- 			},
-- 			icon = {
-- 				string = set_mode_icon,
-- 			},
-- 		})
--
-- 		if string.find(modeOutput, "main") then
-- 			mode_bracket:set({ background = { color = colors.with_alpha(colors.black, 0.3) } })
-- 		elseif string.find(modeOutput, "resize") then
-- 			mode_bracket:set({ background = { color = colors.with_alpha(colors.purple, 0.5) } })
-- 		elseif string.find(modeOutput, "service") then
-- 			mode_bracket:set({ background = { color = colors.with_alpha(colors.orange, 0.9) } })
-- 		elseif string.find(modeOutput, "open") then
-- 			mode_bracket:set({ background = { color = colors.with_alpha(colors.red, 0.5) } })
-- 		elseif string.find(modeOutput, "pass") then
-- 			mode_bracket:set({ background = { color = colors.with_alpha(colors.green, 0.5) } })
-- 		else
-- 			mode_bracket:set({ background = { color = colors.with_alpha(colors.magenta, 0.5) } })
-- 		end
-- 	end)
-- end)

-- mode_item:subscribe("mouse.clicked", function()
--   sbar.exec("aerospace mode main")
--   sbar.trigger("space_windows_change")
-- end)
--
-- mode_item:subscribe("mouse.clicked", function(env)
--   sbar.animate("sin", 3000, function(env)
--     mode_item:set({ popup = { drawing = "toggle" } })
--   end)
-- end)
