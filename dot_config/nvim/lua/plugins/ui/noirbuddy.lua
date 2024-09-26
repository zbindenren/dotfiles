local status_ok, noir = pcall(require, 'noirbuddy')
if not status_ok then
  return
end

local colorbuddy = require('colorbuddy')
-- local Color = colorbuddy.Color
local Group = colorbuddy.Group
local c = colorbuddy.colors
-- local g = colorbuddy.groups
local s = colorbuddy.styles

-- https://coolors.co/gradient-palette/f2f2f2-000000?number=10
noir.setup({
  colors = {
    background = '#ffffff',
    primary = '#03045E',
    secondary = '#03045E',
    noir_9 = '#EDF2FB',
    noir_8 = '#D3D8EA',
    noir_7 = '#B9BDD8',
    noir_6 = '#9FA3C7',
    noir_5 = '#8588B5',
    noir_4 = '#6B6EA4',
    noir_3 = '#515392',
    noir_2 = '#373981',
    noir_1 = '#1D1E6F',
    noir_0 = '#03045E',
    diagnostic_error = '#CE4257',
    diagnostic_warning = '#ffac81',
    diagnostic_info = '#B9BDD8',
    diagnostic_hint = '#B9BDD8',
    diff_add = '#40916C',
    diff_change = '#B9BDD8',
    diff_delete = '#CE4257',
  },
  styles = {
    italic = true,
    bold = true,
    underline = false,
    undercurl = true,
  },
})

Group.new("@keyword", c.primary, nil, s.bold)
Group.new("@keyword.function", c.primary, nil, s.bold)
Group.new("@operator", c.primary, nil, s.bold)
Group.new("@constant", c.primary, nil, s.bold)
Group.new("@punctuation.bracket", c.primary, nil, nil)
Group.new("@type.builtin", c.primary, nil, nil)
