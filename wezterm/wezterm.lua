local wezterm = require 'wezterm'
local act = wezterm.action
local mux = wezterm.mux
local config = wezterm.config_builder()

config.color_scheme = 'xscriptor-theme'
config.color_scheme_dirs = { wezterm.home_dir .. '/.config/wezterm/colors' }

config.font = wezterm.font_with_fallback({ 'AnonymicePro Nerd Font', 'JetBrains Mono', 'Symbols Nerd Font', 'Noto Color Emoji' })
config.font_size = 13.0
config.harfbuzz_features = { 'calt=1', 'clig=1', 'liga=1' }
config.bold_brightens_ansi_colors = true
config.line_height = 1.06

config.window_decorations = 'RESIZE'
config.native_macos_fullscreen_mode = true
config.window_padding = { left = 10, right = 10, top = 8, bottom = 8 }
config.window_background_opacity = 0.92
config.macos_window_background_blur = 20
config.kde_window_background_blur = 10
config.inactive_pane_hsb = { saturation = 0.9, brightness = 0.8 }
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false
config.use_fancy_tab_bar = true
config.show_close_tab_button_in_tabs = true
config.window_frame = { font = wezterm.font('JetBrains Mono'), font_size = 11.0 }

config.enable_scroll_bar = true
config.min_scroll_bar_height = '2cell'
config.scrollback_lines = 100000
config.selection_word_boundary = ' \t\n{}[]()"\'`.,;:<>!?@#$%^&*+=|~'
config.audible_bell = 'Disabled'
config.visual_bell = { fade_in_function = 'EaseIn', fade_in_duration_ms = 80, fade_out_function = 'EaseOut', fade_out_duration_ms = 80 }
config.colors = { visual_bell = '#202020' }
config.window_close_confirmation = 'NeverPrompt'
config.skip_close_confirmation_for_processes_named = { 'bash', 'sh', 'zsh', 'fish', 'tmux', 'nu', 'cmd.exe', 'pwsh.exe', 'powershell.exe' }

config.term = 'wezterm'
config.set_environment_variables = { COLORTERM = 'truecolor' }

config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }
config.keys = {
  { key = '|', mods = 'LEADER|SHIFT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = '-', mods = 'LEADER', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
  { key = 'c', mods = 'LEADER', action = act.SpawnTab 'CurrentPaneDomain' },
  { key = 'p', mods = 'LEADER', action = act.ActivateTabRelative(-1) },
  { key = 'n', mods = 'LEADER', action = act.ActivateTabRelative(1) },
  { key = 'h', mods = 'LEADER', action = act.ActivatePaneDirection 'Left' },
  { key = 'j', mods = 'LEADER', action = act.ActivatePaneDirection 'Down' },
  { key = 'k', mods = 'LEADER', action = act.ActivatePaneDirection 'Up' },
  { key = 'l', mods = 'LEADER', action = act.ActivatePaneDirection 'Right' },
  { key = 'z', mods = 'LEADER', action = act.TogglePaneZoomState },
  { key = 'f', mods = 'LEADER', action = act.ToggleFullScreen },
  { key = 'R', mods = 'LEADER|SHIFT', action = act.ReloadConfiguration },
  { key = 'w', mods = 'SHIFT|CTRL', action = act.CloseCurrentTab { confirm = false } },
  { key = 'r', mods = 'LEADER', action = act.ActivateKeyTable { name = 'resize_pane', one_shot = false } },
  { key = 'a', mods = 'LEADER', action = act.ActivateKeyTable { name = 'activate_pane', timeout_milliseconds = 1000 } },
}

config.key_tables = {
  resize_pane = {
    { key = 'LeftArrow', action = act.AdjustPaneSize { 'Left', 3 } },
    { key = 'h', action = act.AdjustPaneSize { 'Left', 3 } },
    { key = 'RightArrow', action = act.AdjustPaneSize { 'Right', 3 } },
    { key = 'l', action = act.AdjustPaneSize { 'Right', 3 } },
    { key = 'UpArrow', action = act.AdjustPaneSize { 'Up', 3 } },
    { key = 'k', action = act.AdjustPaneSize { 'Up', 3 } },
    { key = 'DownArrow', action = act.AdjustPaneSize { 'Down', 3 } },
    { key = 'j', action = act.AdjustPaneSize { 'Down', 3 } },
    { key = 'Escape', action = 'PopKeyTable' },
  },
  activate_pane = {
    { key = 'LeftArrow', action = act.ActivatePaneDirection 'Left' },
    { key = 'h', action = act.ActivatePaneDirection 'Left' },
    { key = 'RightArrow', action = act.ActivatePaneDirection 'Right' },
    { key = 'l', action = act.ActivatePaneDirection 'Right' },
    { key = 'UpArrow', action = act.ActivatePaneDirection 'Up' },
    { key = 'k', action = act.ActivatePaneDirection 'Up' },
    { key = 'DownArrow', action = act.ActivatePaneDirection 'Down' },
    { key = 'j', action = act.ActivatePaneDirection 'Down' },
  },
}

wezterm.on('update-right-status', function(window, pane)
  local name = window:active_key_table()
  local bat = ''
  local info = wezterm.battery_info()
  if info and #info > 0 then
    local b = info[1].state_of_charge or 0
    bat = string.format(' %.0f%%', b * 100)
  end
  local clock = wezterm.strftime('%H:%M')
  local prefix = name and ('TABLE: ' .. name .. '  ') or ''
  window:set_right_status(prefix .. bat .. '  ' .. clock)
end)

wezterm.on('format-tab-title', function(tab, tabs, panes, c, hover, max_width)
  local index = tab.tab_index + 1
  local title = tab.active_pane.title
  return { { Text = ' ' .. index .. ': ' .. title .. ' ' } }
end)

wezterm.on('gui-startup', function(cmd)
  local tab, pane, window = mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

wezterm.on('user-var-changed', function(window, pane, name, value)
  if name == 'theme' then
    local overrides = window:get_config_overrides() or {}
    if value == 'default' then
      overrides.color_scheme = nil
    else
      overrides.color_scheme = value
    end
    window:set_config_overrides(overrides)
  end
end)

return config
