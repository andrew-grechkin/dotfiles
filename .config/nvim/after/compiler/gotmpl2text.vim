if exists("current_compiler")
  finish
endif
let current_compiler = "gotmpl2text"

if exists(":CompilerSet") != 2
  command -nargs=* CompilerSet setlocal <args>
endif

" Run gotmpl2text on stdin with current file
CompilerSet makeprg=gotmpl2text\ <\ %

" gotmpl2text prints one 'template: PATH:LINE:COL: MSG' line per frame in the
" render error chain, so each frame lands as its own quickfix entry and :cnext
" walks stdin -> preload -> deeper preloads. Leading '%.%#' tolerates output
" that gets prefixed by partial template render (e.g. 'Report:\n  template:').
" STDIN frames arrive with bufnr=0 (no matching buffer) and are remapped to
" the current buffer by the ftplugin's QuickFixCmdPost autocmd.
CompilerSet errorformat=%E%.%#template:\ %f:%l:%c:\ %m,%-G%.%#
