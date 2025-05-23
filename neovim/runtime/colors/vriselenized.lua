local solarized_flat = require('solarized.solarized-flat.highlights')
local lightColors = {
	none = {'none', 'none'},
	base2   = {'#073642',23},
	red     = {'#dc322f',203},
	green   = {'#859900',142},
	yellow  = {'#b58900',178},
	blue    = {'#268bd2',38},
	magenta = {'#d33682',169},
	cyan    = {'#2aa198',37},
	base02  = {'#eee8d5',230},
	base3   = {'#002b36',23},
	orange  = {'#cb4b16',166},
	base1   = {'#586e75',102},
	base0   = {'#657b83',103},
	base00  = {'#839496',145},
	violet  = {'#6c71c4',104},
	base01  = {'#93a1a1',145},
	base03  = {'#fdf6e3',231},
	back    = {'#fdf6e3',231},
	err_bg = {'#fdf6e3',231}
}
local darkColors = {
	none = {'none', 'none'},
	base02 = {'#184956',23},
	red = {'#fa5750',203},
	green = {'#75b938',142},
	yellow = {'#dbb32d',178},
	blue = {'#4695f7',38},
	magenta = {'#f275be',169},
	cyan = {'#41c7b9',37},
	base2 = {'#ece3cc',230},
	base03 = {'#002b36',23},
	back = {'#002b36',23},
	orange = {'#ed8649',166},
	base01 = {'#586e75',102},
	base00 = {'#586e75',103},
	base0 = {'#839496',145},
	violet = {'#6c71c4',104},
	base1 = {'#cad8d9',145},
	base3 = {'#fbf3db',231},
	err_bg = {'#fbf3db',231}
}

if vim.o.bg == 'light' then
	solarized_flat.load_syntax(lightColors)
	solarized_flat.terminal_colors(lightColors)
end

if vim.o.bg == 'dark' then
	solarized_flat.load_syntax(darkColors)
	solarized_flat.terminal_colors(darkColors)
end
