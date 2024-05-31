-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
-- config.color_scheme = 'AdventureTime'

-- and finally, return the configuration to wezterm


config.keys = {
  -- This will create a new split and run the `top` program inside it
  {
    key = 'E',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.SplitPane {
      direction = 'Left',
      command = { args = { 'zsh' } },
      size = { Percent = 50 },
    },
  },
  {
    key = 'O',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.SplitPane {
      direction = 'Down',
      command = { args = { 'zsh' } },
      size = { Percent = 50 },
    },
  },
  { key = "LeftArrow", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Left") },
  -- Move to the pane on the right
  { key = "RightArrow", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Right") },
  -- Move to the pane above
  { key = "UpArrow", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Up") },
  -- Move to the pane below
  { key = "DownArrow", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Down") },
}

return config
