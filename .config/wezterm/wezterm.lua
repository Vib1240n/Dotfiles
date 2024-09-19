-- Pull in the wezterm API
local wezterm = require("wezterm")
local act = wezterm.action

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices
config.font = wezterm.font("Geist Mono")
config.font = wezterm.font_with_fallback({
	"Fira Code",
	"Jetbrains Nerd Font Mono",
})

harfbuzz_features = { "zero", "ss01", "cv05" }
config.window_background_opacity = 0.75
config.macos_window_background_blur = 30

-- For example, changing the color scheme:
config.color_scheme = "Aci (Gogh)"
config.window_frame = {
	-- The font used in the tab bar.
	-- Roboto Bold is the default; this font is bundled
	-- with wezterm.
	-- Whatever font is selected here, it will have the
	-- main font setting appended to it to pick up any
	-- fallback fonts you may have used there.
	--   font = wezterm.font { family = 'Geist Mono', weight = 'Bold' },

	-- The size of the font in the tab bar.
	-- Default to 10.0 on Windows but 12.0 on other systems
	font_size = 15.0,

	-- The overall background color of the tab bar when
	-- the window is focused
	active_titlebar_bg = "#005566",

	-- The overall background color of the tab bar when
	-- the window is not focused
	inactive_titlebar_bg = "#333333",
}

config.window_decorations = "RESIZE"

config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
-- config.disable_default_key_bindings = true
config.keys = {
	{
		key = "s",
		mods = "LEADER|SHIFT",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	-- {
	--     key = 'w',
	--     mods = 'ALT',
	--     action = act.SendString("∑")
	-- },
	-- {
	-- 	key='a',
	-- 	mods='ALT',
	-- 	action = act.SendString("å")
	-- },
	-- {
	-- 	key='s',
	-- 	mods='ALT',
	-- 	action = act.SendString("ß")
	-- },
	-- {
	-- 	key='d',
	-- 	mods='ALT',
	-- 	action = act.SendString("∂")
	-- }
}
config.tab_bar_at_bottom = true
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = true
config.colors = {
	tab_bar = {
		-- The color of the strip that goes along the top of the window
		-- (does not apply when fancy tab bar is in use)
		background = "#3366ff",

		-- The active tab is the one that has focus in the window
		active_tab = {
			-- The color of the background area for the tab
			bg_color = "#005566",
			-- The color of the text for the tab
			fg_color = "#ffffff",

			-- Specify whether you want "Half", "Normal" or "Bold" intensity for the
			-- label shown for this tab.
			-- The default is "Normal"
			intensity = "Bold",

			-- Specify whether you want "None", "Single" or "Double" underline for
			-- label shown for this tab.
			-- The default is "None"
			underline = "Double",

			-- Specify whether you want the text to be italic (true) or not (false)
			-- for this tab.  The default is false.
			italic = false,

			-- Specify whether you want the text to be rendered with strikethrough (true)
			-- or not for this tab.  The default is false.
			strikethrough = false,
		},

		-- Inactive tabs are the tabs that do not have focus
		inactive_tab = {
			bg_color = "#1b1032",
			fg_color = "#808080",

			-- The same options that were listed under the `active_tab` section above
			-- can also be used for `inactive_tab`.
		},

		-- You can configure some alternate styling when the mouse pointer
		-- moves over inactive tabs
		inactive_tab_hover = {
			bg_color = "#3b3052",
			fg_color = "#909090",
			italic = true,

			-- The same options that were listed under the `active_tab` section above
			-- can also be used for `inactive_tab_hover`.
		},

		-- The new tab button that let you create new tabs
		new_tab = {
			bg_color = "#1b1032",
			fg_color = "#808080",

			-- The same options that were listed under the `active_tab` section above
			-- can also be used for `new_tab`.
		},

		-- You can configure some alternate styling when the mouse pointer
		-- moves over the new tab button
		new_tab_hover = {
			bg_color = "#3b3052",
			fg_color = "#909090",
			italic = true,

			-- The same options that were listed under the `active_tab` section above
			-- can also be used for `new_tab_hover`.
		},
	},
	cursor_fg = "black",
	cursor_bg = "#FE5E0A",
	cursor_border = "#FE5E0A",
}

-- wezterm.on('update-right-status', function(window, pane)
--   local leader = ''
--   if window:leader_is_active() then
--     leader = 'LEADER'
--   end
--   window:set_right_status(leader)
-- end)

-- return {
--   leader = { key = 'a', mods = 'CTRL' },
--   colors = {
--     compose_cursor = 'orange',
--   },
--   config
-- }

-- and finally, return the configuration to wezterm
return config
