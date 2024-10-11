if exists("current_compiler")
	finish
endif
let current_compiler = "deno"

" error: TS18004 [ERROR]: No value exists in scope for the shorthand property 'y'. Either declare one or provide an initializer.
"     marks: [Plot.dot(data.toRecords(), { x, y, fill: 'species' })],
"                                             ^
"     at file:///home/agrechkin/git/private/deno/plot/main.ts:15:45

" CompilerSet errorformat=%Eerror:\ %m,%C,%C,%C\ \ \ \ at\ file://%f:%l:%c,%Z
CompilerSet errorformat=%ACheck%.%#,
	\%C%trror:\ TS%n\ [ERROR]:\ %m,
	\%C\ \ \ \ marks%.%#,
	\%C%p^,
	\%C%.%#file://%f:%l:%c,
	\%Z
CompilerSet makeprg=deno-check\ %:S

nnoremap <leader>m :silent make\|redraw!\|cc<CR>
