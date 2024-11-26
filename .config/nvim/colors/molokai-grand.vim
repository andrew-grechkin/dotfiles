" Vim color file
"
" Author: Tomas Restrepo <tomas@winterdom.com>
" https://github.com/tomasr/molokai
"
" Note: Based on the Monokai theme for TextMate
" by Wimer Hazenberg and its darker variant
" by Hamish Stuart Macpherson

hi clear
if exists('syntax_on')
	syntax reset
endif

let g:colors_name='molokai-grand'

if exists('g:molokai_original')
	let s:molokai_original = g:molokai_original
else
	let s:molokai_original = 0
endif

" :lua vim.notify(require'nvim-treesitter.ts_utils'.get_node_at_cursor():__tostring())
" :lua vim.notify(vim.inspect(getmetatable(require'nvim-treesitter.ts_utils'.get_node_at_cursor(0))))

if &termguicolors ==# 1
	hi Boolean                  guifg=#AE81F0
	hi Character                guifg=#E6DB74
	hi Comment                  guifg=#777777
	hi Conditional              guifg=#F92672                             gui=bold
	hi Constant                 guifg=#AE81FF                             gui=bold
	hi Debug                    guifg=#BCA3A3                             gui=bold
	hi Define                   guifg=#66D9EF
	hi Delimiter                guifg=#8F8F8F
	hi Error                    guifg=#D6CB64 guibg=#1E0010
	hi Exception                guifg=#A6E22E                             gui=bold
	hi Float                    guifg=#AE81FF
	hi Function                 guifg=#A6E22E
	hi Identifier               guifg=#FD971F
	hi Ignore                   guifg=#808080 guibg=bg
	hi Keyword                  guifg=#F92672                             gui=bold
	hi Label                    guifg=#45B2B4                             gui=NONE
	hi Macro                    guifg=#C4BE89                             gui=italic
	hi Number                   guifg=#AE81FF
	hi Operator                 guifg=#F92672
	hi PreCondit                guifg=#A6E22E                             gui=bold
	hi PreProc                  guifg=#A6E22E
	hi Repeat                   guifg=#F92672                             gui=bold
	hi Special                  guifg=#66D9EF                             gui=bold
	hi SpecialChar              guifg=#F92672                             gui=bold
	hi SpecialComment           guifg=#999999
	hi Statement                guifg=#F95050                             gui=NONE
	hi StorageClass             guifg=#FD971F                             gui=italic
	hi String                   guifg=#C6BB74
	hi Structure                guifg=#66D9EF
	hi Tag                      guifg=#F92672                             gui=italic
	hi Todo                     guifg=#FFFFFF guibg=bg                    gui=bold
	hi Type                     guifg=#66D9EF                             gui=NONE
	hi Typedef                  guifg=#66D9EF

	hi LspInlayHint             guifg=#808080
	hi LspCodeLens              guifg=#808080
	hi LspCodeLensSeparator     guifg=#808080

	hi ColorColumn                            guibg=#232526
	hi Cursor                   guifg=#000000 guibg=#F8F8F0
	hi CursorColumn                           guibg=#293739
	hi CursorLine                             guibg=#293739
	hi CursorLineNr             guifg=#FD971F                             gui=NONE
	hi DiffAdd                                guibg=#203020
	hi DiffChange                             guibg=#303020
	hi DiffDelete               guifg=#960050 guibg=#302020
	hi DiffText                               guibg=#6C4C20               gui=undercurl
	hi Directory                guifg=#A6E22E                             gui=bold
	hi ErrorMsg                 guifg=#F92672 guibg=#232526               gui=bold
	hi FoldColumn               guifg=#465457 guibg=#000000
	hi Folded                   guifg=#465457 guibg=#000000
	hi IncSearch                guifg=#C4BE89 guibg=#000000
	hi LineNr                   guifg=#465457 guibg=#232526
	hi MatchParen               guifg=#000000 guibg=#FD971F               gui=bold
	hi ModeMsg                  guifg=#E6DB74
	hi MoreMsg                  guifg=#E6DB74
	hi NonText                  guifg=#222023
	hi Normal                                 guibg=NONE                                  ctermbg=NONE
	hi manBold                                                            gui=bold
	hi manItalic                                                          gui=italic
	hi manUnderline                                                       gui=underline
	hi Normal                   guifg=#D8D8D2 guibg=NONE
	hi Pmenu                    guifg=#66D9EF guibg=#000000
	hi PmenuSbar                              guibg=#080808
	hi PmenuSel                               guibg=#808080
	hi PmenuThumb               guifg=#66D9EF
	hi Question                 guifg=#66D9EF
	hi Search                   guifg=#000000 guibg=#9F8762
	hi SignColumn               guifg=#A6E22E guibg=#232526
	hi SpecialKey               guifg=#66D9EF                             gui=italic
	hi SpellBad                               guibg=#382020 guisp=#FF0000 gui=underdouble
	hi SpellCap                               guibg=#382020 guisp=#7070F0 gui=undercurl
	hi SpellLocal                             guibg=#382020 guisp=#70F0F0 gui=underdotted
	hi SpellRare                              guibg=#382020 guisp=#FFFFFF gui=underdashed
	hi StatusLine               guifg=#455354 guibg=bg
	hi StatusLineNC             guifg=#808080 guibg=#080808
	hi TabLine                  guifg=#808080 guibg=#1B1D1E               gui=NONE
	hi TabLineFill              guifg=#1B1D1E guibg=#1B1D1E
	hi Title                    guifg=#EF5939
	hi VertSplit                guifg=#808080 guibg=#080808               gui=bold
	hi Visual                                 guibg=#403D3D
	hi VisualNOS                              guibg=#403D3D
	hi WarningMsg               guifg=#FFFFFF guibg=#333333               gui=standout
	hi WildMenu                 guifg=#66D9EF

	hi GitSignsCurrentLineBlame guifg=#605E66
	hi NotifyBackground                       guibg=#000000

	hi IlluminatedWordText                                                gui=underline
	hi IlluminatedWordRead                    guibg=#003300               gui=underdotted
	hi IlluminatedWordWrite                   guibg=#3b2e20               gui=underdotted,bold
else
	if $TERM =~# '256'
		hi Boolean              ctermfg=135
		hi Character            ctermfg=144
		hi Comment              ctermfg=59
		hi Conditional          ctermfg=161                             cterm=bold
		hi Constant             ctermfg=135                             cterm=bold
		hi Debug                ctermfg=225                             cterm=bold
		hi Define               ctermfg=81
		hi Delimiter            ctermfg=241
		hi Error                ctermfg=219         ctermbg=89
		hi Exception            ctermfg=118                             cterm=bold
		hi Float                ctermfg=135
		hi Function             ctermfg=118
		hi Identifier           ctermfg=208                             cterm=NONE
		hi Ignore               ctermfg=244         ctermbg=232
		hi Keyword              ctermfg=161                             cterm=bold
		hi Label                ctermfg=229                             cterm=NONE
		hi Macro                ctermfg=193
		hi Number               ctermfg=135
		hi Operator             ctermfg=161
		hi PreCondit            ctermfg=118                             cterm=bold
		hi PreProc              ctermfg=118
		hi Repeat               ctermfg=161                             cterm=bold
		hi Special              ctermfg=81
		hi SpecialChar          ctermfg=161                             cterm=bold
		hi SpecialComment       ctermfg=245                             cterm=bold
		hi Statement            ctermfg=161                             cterm=bold
		hi StorageClass         ctermfg=208
		hi String               ctermfg=144
		hi Structure            ctermfg=81
		hi Tag                  ctermfg=161
		hi Todo                 ctermfg=231         ctermbg=232         cterm=bold
		hi Type                 ctermfg=81                              cterm=NONE
		hi Typedef              ctermfg=81

		hi ColorColumn                              ctermbg=236
		hi Cursor               ctermfg=16          ctermbg=253
		hi CursorColumn                             ctermbg=236
		hi CursorLine                               ctermbg=234         cterm=NONE
		hi CursorLineNr         ctermfg=208                             cterm=NONE
		hi DiffAdd                                  ctermbg=24
		hi DiffChange           ctermfg=181         ctermbg=239
		hi DiffDelete           ctermfg=162         ctermbg=53
		hi DiffText                                 ctermbg=102         cterm=bold
		hi Directory            ctermfg=118                             cterm=bold
		hi ErrorMsg             ctermfg=199         ctermbg=16          cterm=bold
		hi FoldColumn           ctermfg=67          ctermbg=16
		hi Folded               ctermfg=67          ctermbg=16
		hi IncSearch            ctermfg=193         ctermbg=16
		hi LineNr               ctermfg=250         ctermbg=236
		hi MatchParen           ctermfg=233         ctermbg=208         cterm=bold
		hi ModeMsg              ctermfg=229
		hi MoreMsg              ctermfg=229
		hi NonText              ctermfg=59
		hi Normal               ctermfg=252
		hi Pmenu                ctermfg=81          ctermbg=16
		hi PmenuSbar                                ctermbg=232
		hi PmenuSel             ctermfg=255         ctermbg=242
		hi PmenuThumb           ctermfg=81
		hi Question             ctermfg=81
		hi Search               ctermfg=0           ctermbg=222         cterm=NONE
		hi SignColumn           ctermfg=118         ctermbg=235
		hi SpecialKey           ctermfg=59
		hi SpellBad                                 ctermbg=52
		hi SpellCap                                 ctermbg=17
		hi SpellLocal                               ctermbg=17
		hi SpellRare            ctermfg=NONE        ctermbg=NONE        cterm=reverse
		hi StatusLine           ctermfg=238         ctermbg=253
		hi StatusLineNC         ctermfg=244         ctermbg=232
		hi Title                ctermfg=166
		hi VertSplit            ctermfg=244         ctermbg=232         cterm=bold
		hi Visual                                   ctermbg=235
		hi VisualNOS                                ctermbg=238
		hi WarningMsg           ctermfg=231         ctermbg=238         cterm=bold
		hi WildMenu             ctermfg=81          ctermbg=16
	else " 16 colors only
		hi Boolean              ctermfg=Blue
		hi Character            ctermfg=Yellow
		hi Comment              ctermfg=Gray
		hi Conditional          ctermfg=Red
		hi Constant             ctermfg=Blue
		hi Debug                ctermfg=Gray
		hi Define               ctermfg=Cyan
		hi Delimiter            ctermfg=White
		hi Error                ctermfg=Brown       ctermbg=Red
		hi Exception            ctermfg=Brown
		hi Float                ctermfg=Blue
		hi Function             ctermfg=Green
		hi Identifier           ctermfg=Magenta
		hi Ignore               ctermfg=DarkGray
		hi Keyword              ctermfg=Red
		hi Label                ctermfg=Yellow
		hi Macro                ctermfg=Yellow
		hi Number               ctermfg=Blue
		hi Operator             ctermfg=White
		hi PreCondit            ctermfg=Brown
		hi PreProc              ctermfg=Brown
		hi Repeat               ctermfg=Red
		hi Special              ctermfg=Cyan
		hi SpecialChar          ctermfg=Red
		hi SpecialComment       ctermfg=DarkGray
		hi Statement            ctermfg=Red
		hi StorageClass         ctermfg=Yellow
		hi String               ctermfg=Green
		hi Structure            ctermfg=Cyan
		hi Tag                  ctermfg=Red
		hi Todo                 ctermfg=White       ctermbg=Yellow
		hi Type                 ctermfg=Cyan
		hi Typedef              ctermfg=Cyan

"		hi ColorColumn                              ctermbg=236
"		hi Conceal              ctermfg=            ctermbg=
"		hi Cursor               ctermfg=16          ctermbg=253
		hi CursorColumn                             ctermbg=DarkRed     cterm=bold
"		hi CursorIM             ctermfg=            ctermbg=
		hi CursorLine                               ctermbg=NONE        cterm=bold
"		hi CursorLineFold       ctermfg=            ctermbg=
"		hi CursorLineNr         ctermfg=208                             cterm=NONE
"		hi CursorLineSign       ctermfg=            ctermbg=
"		hi DiffAdd                                  ctermbg=24
"		hi DiffChange           ctermfg=181         ctermbg=239
"		hi DiffDelete           ctermfg=162         ctermbg=53
"		hi DiffText                                 ctermbg=102         cterm=bold
"		hi Directory            ctermfg=118                             cterm=bold
"		hi EndOfBuffer          ctermfg=            ctermbg=
"		hi ErrorMsg             ctermfg=199         ctermbg=16          cterm=bold
"		hi FoldColumn           ctermfg=67          ctermbg=16
"		hi Folded               ctermfg=67          ctermbg=16
"		hi IncSearch            ctermfg=193         ctermbg=16
"		hi LineNr               ctermfg=250         ctermbg=236
"		hi LineNrAbove          ctermfg=            ctermbg=
"		hi LineNrBelow          ctermfg=            ctermbg=
"		hi MatchParen           ctermfg=233         ctermbg=208         cterm=bold
"		hi ModeMsg              ctermfg=229
"		hi MoreMsg              ctermfg=229
"		hi MsgArea              ctermfg=            ctermbg=
"		hi MsgSeparator         ctermfg=            ctermbg=
"		hi NonText              ctermfg=59
"		hi Normal               ctermfg=252         ctermbg=233
"		hi NormalFloat          ctermfg=252         ctermbg=233
"		hi NormalNC             ctermfg=252         ctermbg=233
"		hi Pmenu                ctermfg=81          ctermbg=16
"		hi PmenuSbar                                ctermbg=232
"		hi PmenuSel             ctermfg=255         ctermbg=242
"		hi PmenuThumb           ctermfg=81
"		hi Question             ctermfg=81
"		hi QuickFixLine         ctermfg=            ctermbg=
"		hi Search               ctermfg=0           ctermbg=222         cterm=NONE
"		hi SignColumn           ctermfg=118         ctermbg=235
"		hi SpecialKey           ctermfg=59
"		hi SpellBad                                 ctermbg=52
"		hi SpellCap                                 ctermbg=17
"		hi SpellLocal                               ctermbg=17
"		hi SpellRare            ctermfg=NONE        ctermbg=NONE        cterm=reverse
"		hi StatusLine           ctermfg=238         ctermbg=253
"		hi StatusLineNC         ctermfg=244         ctermbg=232
"		hi Substitute           ctermfg=            ctermbg=
"		hi TabLine              ctermfg=            ctermbg=
"		hi TabLineFill          ctermfg=            ctermbg=
"		hi TabLineSel           ctermfg=            ctermbg=
"		hi TermCursor           ctermfg=            ctermbg=
"		hi TermCursorNc         ctermfg=            ctermbg=
"		hi Title                ctermfg=166
"		hi Visual                                   ctermbg=DarkRed
"		hi VisualNOS                                ctermbg=DarkMagenta
"		hi WarningMsg           ctermfg=            ctermbg=
		hi Whitespace           ctermfg=DarkGray
""		hi WildMenu             ctermfg=            ctermbg=
"		hi WinSeparator         ctermfg=            ctermbg=
	end
end

" Must be at the end, because of ctermbg=234 bug.
" https://groups.google.com/forum/#!msg/vim_dev/afPqwAFNdrU/nqh6tOM87QUJ
set background=dark
