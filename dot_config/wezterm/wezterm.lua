local wezterm = require("wezterm")
local act = wezterm.action

local config = {}
if wezterm.config_builder then
	config = wezterm.config_builder()
end

local function macCMDtoCtrl()
	local keys = "abcdefghijklmnopqrstuvwxyz"
	local keymappings = {}

	for i = 1, #keys do
		local c = keys:sub(i, i)
		table.insert(keymappings, {
			key = c,
			mods = "CMD",
			action = act.SendKey({
				key = c,
				mods = "CTRL",
			}),
		})
	end
	return keymappings
end

config.font_size = 20
config.window_close_confirmation = "NeverPrompt"
config.default_prog = { "/opt/homebrew/bin/fish" }
-- config.line_height=1
config.hide_tab_bar_if_only_one_tab = true
config.color_scheme = "Catppuccin Latte"
config.audible_bell = "Disabled"
config.keys = macCMDtoCtrl()

return config
