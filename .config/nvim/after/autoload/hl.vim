function! hl#show()
	execute 'TSHighlightCapturesUnderCursor'
endfun

function! hl#show()
    let l:synNames = []
    let l:idx = 0
    for id in synstack(line('.'), col('.'))
        call add(l:synNames, printf('%s%s -> %s', repeat(' ', idx), synIDattr(id, 'name'), synIDattr(synIDtrans(id), 'name')))
        let l:idx+=1
    endfor
    echo join(l:synNames, "\n")
endfun

" :noremap <F11> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<' . synIDattr(synID(line("."),col("."),0),"name") . "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>
