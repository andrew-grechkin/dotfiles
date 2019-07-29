function! tabs#beginning()
	let saved_view = winsaveview()
    execute '%s@^\(\ \{'.&tabstop.'\}\)\+@\=repeat("\t", len(submatch(0))/'.&tabstop.')@e'
    call winrestview(saved_view)
endfunction
