local status_ok, noir = pcall(require, 'noirbuddy')
if not status_ok then
  return
end

local colorbuddy = require('colorbuddy')
-- local Color = colorbuddy.Color
local Group = colorbuddy.Group
-- local c = colorbuddy.colors
-- local g = colorbuddy.groups
local s = colorbuddy.styles


-- https://coolors.co/gradient-palette/f2f2f2-000000?number=10
noir.setup({
  colors = {
    background = '#ffffff',
    primary = '#000000',
    secondary = '#515151',
    noir_0 = '#000000',
    noir_1 = '#1B1B1B',
    noir_2 = '#363636',
    noir_3 = '#515151',
    noir_4 = '#6C6C6C',
    noir_5 = '#868686',
    noir_6 = '#A1A1A1',
    noir_7 = '#BCBCBC',
    noir_8 = '#D7D7D7',
    noir_9 = '#F2F2F2',
    diagnostic_error = '#CE4257',
    diagnostic_warning = '#FF9B54',
    diagnostic_info = '#219EBC',
    diagnostic_hint = '#219EBC',
    diff_add = '#40916C',
    diff_change = '#219EBC',
    diff_delete = '#CE4257',
  },
  styles = {
    italic = true,
    bold = true,
    underline = false,
    undercurl = true,
  },
})

Group.new("@keyword", nil, nil, s.bold)
