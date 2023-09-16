" => Encoding ---------------------------------------------------------------------------------------------------- {{{1

setglobal encoding=utf-8                                                       " Set utf-8 as default encoding
setglobal fileencodings=ucs-bom,utf-8,default,cp1251                           " Order of encodings detection

augroup SetDefaultEncoding
	autocmd!
	autocmd BufNewFile,BufRead * try
	autocmd BufNewFile,BufRead *     setlocal encoding=utf-8
	autocmd BufNewFile,BufRead * endtry
augroup END

augroup SetDefaultBom
	autocmd!
	autocmd BufNewFile *.txt try
	autocmd BufNewFile *.txt     setlocal bomb                                 " Set BOM
	autocmd BufNewFile *.txt endtry
augroup END
