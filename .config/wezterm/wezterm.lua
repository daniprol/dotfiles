-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- This is where you actually apply your config choices
--

-- COMMAND PALETTE with CTRL+ALT+P
config.keys = {
	{
		key = "P",
		mods = "CTRL",
		action = wezterm.action.ActivateCommandPalette,
	},
	-- paste from the clipboard
	-- WARNING: notice the lowercase "v" here!!
	{ key = "v", mods = "CTRL", action = wezterm.action.PasteFrom("Clipboard") },
	-- Primary Selection (middle click) is the quick-copy command available in terminals that can be pasted with shift-inser
	-- { key = "V", mods = "CTRL", action = wezterm.action.PasteFrom("PrimarySelection") },
}

-- CREATE NEW LAUNCH OPTIONS
config.launch_menu = {
	{
		args = { "btop" },
		label = "Launch BTOP",
	},
}

-- Colorscheme
--config.color_scheme = 'AdventureTime'
-- config.color_scheme = "Batman"
config.color_scheme = "Dracula"
--config.color_scheme = 'Ocean Dark (Gogh)'
--config.color_scheme = 'One Dark (Gogh)'
--config.color_scheme = 'OneHalfDark'
--config.color_scheme = "OneDark (base16)"
--config.color_scheme = 'nord'
--config.color_scheme = 'OceanicMaterial'
--config.color_scheme = 'OceanicNext (base16)'
--

-- CHANGE BAR CONFIGURATION
--local retrobar = require('retrobar')
--retrobar.configure(config)

local fancybar = require("fancybar")
fancybar.configure(config)

-- default is true, has more "native" look
config.use_fancy_tab_bar = false

-- Background opacity (max: 1.0)
--config.window_background_opacity = 0.95
--config.text_background_opacity = 0.9

-- Font
config.font = wezterm.font("JetBrains Mono")
-- config.font = wezterm.font("FiraCode Nerd Font Mono")
-- config.font = wezterm.font("FiraCode Nerd Font")
--
-- MISSING GLYPHS FIX
config.warn_about_missing_glyphs = false

-- I don't like putting anything at the ege if I can help it.
config.enable_scroll_bar = false
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

-- config.freetype_load_target = "HorizontalLcd"

config.tab_bar_at_bottom = false

-- REMOVES THE APPLICATION TOP BAR WITH THE MINIMIZATION AND EXIT BUTTONS
config.window_decorations = "RESIZE"

-- and finally, return the configuration to wezterm
return config
