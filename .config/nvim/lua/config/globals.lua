GIT_NAME = vim.fn.system({'git', 'config', 'user.name'})
GIT_NAME = string.gsub(GIT_NAME, '%s+$', '')
IS_WORK = GIT_NAME and GIT_NAME == 'Andrei Grechkin'

HOSTNAME = vim.fn.system({'hostname'})
IS_KVM = not not string.find(HOSTNAME, 'king.com')
PRIVATE_DOMAIN = 'boo' .. 'king'
-- SUPERUSER = string.gsub(vim.fn.system('sh -c \'echo $UID\''), '^%s*(.-)%s*$', '%1') == '1027'
-- VIM_CONFIG_FILE = resolve(expand($MYVIMRC))

-- because runtime/ftplugin/perl.vim has a crap perlpath initialization set it upfront to avoid initialization code from
-- running
vim.g.perlpath = ''
