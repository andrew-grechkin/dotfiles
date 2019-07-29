call ale#Set('mysql_sqlfluff_executable', 'sqlfluff')

function! ale_fixers#mysql#sqlfluff#Fix(buffer) abort
    let l:executable = ale#Var(a:buffer, 'mysql_sqlfluff_executable')

    let l:cmd =
    \    ale#Escape(l:executable)
    \    . ' format --dialect mysql'

    return {
    \   'command': l:cmd . ' %t > /dev/null',
    \   'read_temporary_file': 1,
    \}
endfunction
