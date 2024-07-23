setlocal expandtab smarttab shiftwidth=2 softtabstop=2 tabstop=2

function! PuppetGoToDefinition()
	let isk_save = &l:isk

	" [Class['::foo::bar']], file('/path/to/file.sh'), $::is_staging
	" include ::profile_base
	setlocal iskeyword+=:,.,/,],[,',\",\$,-
	let cword = expand('<cword>')
	let &l:isk = isk_save

	let tag_name = cword

	" Removing irrelevant characters from the tag name
	let tag_name = substitute(tag_name, ':$', '', '')
	let tag_name = substitute(tag_name, '^"', '', '')
	let tag_name = substitute(tag_name, '"$', '', '')
	let tag_name = substitute(tag_name, "^'", '', '')
	let tag_name = substitute(tag_name, "'$", '', '')
	let tag_name = substitute(tag_name, '^::', '', '')
	let tag_name = substitute(tag_name, '^[', '', '')
	let tag_name = substitute(tag_name, ']]$', ']', '')

	echo tag_name
	exec('silent! tag ' . tag_name)
endfunction

augroup puppet_go_to_definition
	autocmd FileType puppet nmap <buffer> <C-]> :call PuppetGoToDefinition()<CR>
augroup end
