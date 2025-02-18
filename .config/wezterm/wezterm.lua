-- Pull in the wezterm API
local wezterm = require("wezterm")
local act = wezterm.action

local config = wezterm.config_builder()

config.font = wezterm.font("GeistMono Nerd Font")
config.font = wezterm.font_with_fallback({
	"Fira Code",
	"Jetbrains Nerd Font Mono",
})

harfbuzz_features = { "zero", "ss01", "cv05" }
config.window_background_opacity = 0.65
config.macos_window_background_blur = 50
config.window_frame = {
	font_size = 20.0,
	active_titlebar_bg = "none",
	inactive_titlebar_bg = "#333333",
}
config.font_size = 18
config.window_decorations = "RESIZE"

config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
	{
		key = "v",
		mods = "CTRL|ALT|SHIFT",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "h",
		mods = "CTRL|SHIFT|ALT",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "r",
		mods = "CMD|SHIFT|ALT",
		action = wezterm.action.ReloadConfiguration,
	},
	{
		key = "c",
		mods = "CTRL|ALT|SHIFT",
		action = wezterm.action.CloseCurrentPane({ confirm = false }),
	},
	-- {
	-- 	key = "d",
	-- 	mods = "CTRL|SHIFT|ALT|CMD",
	-- 	actions = wezterm.action.AdjustPaneSize({ "Right", 5 }),
	-- },
	-- {
	-- 	key = "w",
	-- 	mods = "CTRL|SHIFT|ALT|CMD",
	-- 	actions = wezterm.action.AdjustPaneSize({ "Up", 5 }),
	-- },
	-- {
	-- 	key = "a",
	-- 	mods = "CTRL|SHIFT|ALT|CMD",
	-- 	actions = wezterm.action.AdjustPaneSize({ "Left", 5 }),
	-- },
	-- {
	-- 	key = "s",
	-- 	mods = "CTRL|SHIFT|ALT|CMD",
	-- 	actions = wezterm.action.AdjustPaneSize({ "Down", 5 }),
	-- },
}
config.tab_bar_at_bottom = true
config.send_composed_key_when_left_alt_is_pressed = true
config.send_composed_key_when_right_alt_is_pressed = false
config.animation_fps = 1
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"
-- config.use_fancy_tabbar = true

-- config.cursor_thickness = 2
-- config.cursor_blink_rate = 800

config.visual_bell = {
	fade_in_function = "EaseIn",
	fade_in_duration_ms = 350,
	fade_out_function = "EaseOut",
	fade_out_duration_ms = 350,
}
config.colors = {
	visual_bell = "#202020",
	cursor_bg = "#ff6700",
}
config.default_cursor_style = "BlinkingBar"
-- config.hide_tab_bar_if_only_one_tab = true
-- config.colors = {
-- 	tab_bar = {
-- 		-- 	-- background = "none",
-- 		active_tab = {
-- 			-- 		bg_color = "none",
-- 			-- 		fg_color = "#ffffff",
-- 			-- intensity = "Bold",
-- 			-- underline = "Double",
-- 			-- 		italic = true,
-- 			-- 		strikethrough = false,
-- 		},
-- 		-- inactive_tab = {
-- 		-- 		bg_color = "rgba(82, 82, 82, 0.5)",
-- 		-- 		fg_color = "#808080",
-- 		-- 	},
-- 		-- 	inactive_tab_hover = {
-- 		-- 		bg_color = "#3b3052",
-- 		-- 		fg_color = "none",
-- 		-- 		italic = true,
-- 		-- 	},
-- 		-- 	new_tab = {
-- 		-- 		bg_color = "white",
-- 		-- 		fg_color = "#808080",
-- 		-- 	},
-- 		-- 	new_tab_hover = {
-- 		-- 		bg_color = "#3b3052",
-- 		-- 		fg_color = "#909090",
-- 		-- 		italic = true,
-- 		-- 	},
-- 	},
-- 	cursor_fg = "black",
-- 	cursor_bg = "#FE5E0A",
-- 	cursor_border = "none",
-- }
return config
