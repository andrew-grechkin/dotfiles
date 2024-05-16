" Author: Carl Smedstad <carl.smedstad at protonmail dot com>
" Description: sqlfluff for SQL files

let g:ale_mysql_sqlfluff_executable =
\   get(g:, 'ale_mysql_sqlfluff_executable', 'sqlfluff')

let g:ale_mysql_sqlfluff_options =
\   get(g:, 'ale_mysql_sqlfluff_options', '')

function! ale_linters#mysql#sqlfluff#Executable(buffer) abort
    return ale#Var(a:buffer, 'mysql_sqlfluff_executable')
endfunction

function! ale_linters#mysql#sqlfluff#Command(buffer) abort
    let l:executable = ale_linters#mysql#sqlfluff#Executable(a:buffer)
    let l:options = ale#Var(a:buffer, 'mysql_sqlfluff_options')

    let l:cmd =
    \    ale#Escape(l:executable)
    \    . ' lint --dialect mysql'

    let l:cmd .=
    \   ' --format json '
    \   . l:options
    \   . ' %t'

    return l:cmd
endfunction

function! ale_linters#mysql#sqlfluff#Handle(buffer, lines) abort
    let l:output = []
    let l:json_lines = ale#util#FuzzyJSONDecode(a:lines, [])

    if empty(l:json_lines)
        return l:output
    endif

    let l:json = l:json_lines[0]

    " if there's no warning, 'result' is `null`.
    if empty(get(l:json, 'violations'))
        return l:output
    endif

    for l:violation in get(l:json, 'violations', [])
        call add(l:output, {
        \   'filename': l:json.filepath,
        \   'lnum': l:violation.line_no,
        \   'col': l:violation.line_pos,
        \   'text': l:violation.description,
        \   'code': l:violation.code,
        \   'type': 'W',
        \})
    endfor

    return l:output
endfunction
