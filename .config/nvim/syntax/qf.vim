scriptencoding=utf-8

if exists('b:current_syntax')
    finish
else
	let b:current_syntax = 'qf'
endif

syntax match qfFileName       /^[^│]*/              nextgroup=qfSeparatorLeft
syntax match qfSeparatorLeft  /│/         contained nextgroup=qfLineNr
syntax match qfLineNr         /[^│]*/     contained nextgroup=qfSeparatorRight
syntax match qfSeparatorRight /│/         contained nextgroup=qfError,qfWarning,qfInfo,qfNote
syntax match qfError          / E .*$/    contained
syntax match qfWarning        / W .*$/    contained
syntax match qfInfo           / I .*$/    contained
syntax match qfNote           / [NH] .*$/ contained

highlight default link qfFileName       Directory
highlight default link qfSeparatorLeft  Delimiter
highlight default link qfSeparatorRight Delimiter
highlight default link qfLineNr         LineNr
highlight default link qfError          DiagnosticError
highlight default link qfInfo           DiagnosticInfo
highlight default link qfNote           DiagnosticHint
highlight default link qfWarning        DiagnosticWarn
