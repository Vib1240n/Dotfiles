return {
	paddings = 10,
	group_paddings = 5,
	alpha = 1,
	split_height = 60,
	bracket_cr = 15,
	fontXL = 20,
	fontL = 18,
	fontM = 16,
	fontS = 14,
	fontXS = 12,
	iconXL = 38,
	iconL = 28,
	iconM = 22,
	iconS = 20,
	iconXS = 18,

	icons = "sf-symbols", -- alternatively available: NerdFont
	blur = 20,
	-- This is a font configuration for SF Pro and SF Mono (installed manually)
	-- font = require("helpers.default_font"),

	-- Alternatively, this is a font config for JetBrainsMono Nerd Font
	font = {
		text = "JetBrainsMono Nerd Font", -- Used for text
		numbers = "JetBrainsMono Nerd Font", -- Used for numbers
		style_map = {
			["Regular"] = "Regular",
			["Semibold"] = "Medium",
			["Bold"] = "SemiBold",
			["Heavy"] = "Bold",
			["Black"] = "ExtraBold",
			["Italic"] = "Italic",
		},
	},
}
