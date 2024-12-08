function! db#adapter#sqlitetsv#canonicalize(url) abort
  return db#url#canonicalize_file(a:url)
endfunction

function! db#adapter#sqlitetsv#test_file(file) abort
  if getfsize(a:file) >= 100 && readfile(a:file, '', 1)[0] =~# '^SQLite format 3\n'
    return 1
  endif
endfunction

function! s:path(url) abort
  let path = db#url#file_path(a:url)
  if path =~# '^[\/]\=$'
    if !exists('s:session')
      let s:session = tempname() . '.sqlite3'
    endif
    let path = s:session
  endif
  return path
endfunction

function! db#adapter#sqlitetsv#dbext(url) abort
  return {'dbname': s:path(a:url)}
endfunction

function! db#adapter#sqlitetsv#command(url) abort
  return ['sqlite3', s:path(a:url)]
endfunction

function! db#adapter#sqlitetsv#interactive(url) abort
  return db#adapter#sqlitetsv#command(a:url) + ['-column', '-header']
endfunction

function! db#adapter#sqlitetsv#filter(url) abort
  return db#adapter#sqlitetsv#command(a:url) + ['-tabs', '-header']
endfunction

function! db#adapter#sqlitetsv#tables(url) abort
  return split(join(db#systemlist(db#adapter#sqlitetsv#command(a:url) + ['-noheader', '.tables'])))
endfunction

function! db#adapter#sqlitetsv#massage(input) abort
  return a:input . "\n;"
endfunction
