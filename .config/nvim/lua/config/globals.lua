GIT_NAME = vim.fn.system({'git', 'config', 'user.name'})
GIT_NAME = string.gsub(GIT_NAME, '%s+$', '')
IS_WORK = GIT_NAME and GIT_NAME == 'Andrei Grechkin'

HOSTNAME = vim.fn.system({'hostname'})
IS_KVM = not not string.find(HOSTNAME, 'king.com')
PRIVATE_DOMAIN = 'boo' .. 'king'
-- VIM_CONFIG_FILE = resolve(expand($MYVIMRC))
