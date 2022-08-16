" => Commands ---------------------------------------------------------------------------------------------------- {{{1

command! Force1251 :edit! ++enc=cp1251 | set fileformat=unix | set fileencoding=utf-8
command! Force866  :edit! ++enc=cp866  | set fileformat=unix | set fileencoding=utf-8
command! ForceKoi  :edit! ++enc=koi8-r | set fileformat=unix | set fileencoding=utf-8

command! W         :execute ':silent w !sudo tee % > /dev/null' <Bar> :edit!   " Save file with root privileges

command! Retab     call tabs#beginning()
