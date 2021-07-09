" => Commands ---------------------------------------------------------------------------------------------------- {{{1

	command! Force866 :edit! ++enc=cp866  | set ff=unix | set fileencoding=utf-8
	command! ForceKoi :edit! ++enc=koi8-r | set ff=unix | set fileencoding=utf-8

if has('nvim')
	command! W :execute ':w suda://%'
else
	command! W :execute ':silent w !sudo tee % > /dev/null' | :edit!           " Save file with root privileges
endif
