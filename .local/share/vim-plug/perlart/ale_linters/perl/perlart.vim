" Description: This file adds support for checking perl with perlart

call ale#Set('perl_perlart_executable', 'perlart')
call ale#Set('perl_perlart_options', '')
call ale#Set('perl_perlart_showrules', 0)

function! ale_linters#perl#perlart#GetCommand(buffer) abort
    return '%e' . ' %t'
endfunction


function! ale_linters#perl#perlart#Handle(buffer, lines) abort
    let l:pattern = '\v(.+)(\sat\s).+:(\d+):(\d+)'
    let l:output = []

    for l:match in ale#util#GetMatches(a:lines, l:pattern)
        call add(l:output, {
        \   'lnum': l:match[3],
        \   'col': l:match[4],
        \   'text': l:match[1],
        \   'type': 'W'
        \})
    endfor

    return l:output
endfunction

call ale#linter#Define('perl', {
\   'name': 'perlart',
\   'output_stream': 'stdout',
\   'executable': {b -> ale#Var(b, 'perl_perlart_executable')},
\   'command': function('ale_linters#perl#perlart#GetCommand'),
\   'callback': 'ale_linters#perl#perlart#Handle',
\})
