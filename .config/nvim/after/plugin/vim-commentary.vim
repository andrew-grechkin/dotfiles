" url: https://github.com/tpope/vim-commentary

scriptencoding=utf-8
if !plugin#is_loaded('vim-commentary') | finish | endif

nmap     <C-_>                         gcl
vmap     <C-_>                         gc

augroup SettingsVimCommentary
	autocmd!
	autocmd FileType perl,vim let b:commentary_startofline = 1
augroup END
