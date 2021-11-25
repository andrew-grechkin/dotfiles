local status, which_key = pcall(require, 'which-key')
if (not status) then return end

which_key.setup {
	plugins = {
		spelling = {
			enabled     = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
			suggestions = 20,   -- how many suggestions should be shown in the list?
		},
	},
}
