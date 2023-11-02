vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- => man.vim ----------------------------------------------------------------------------------------------------- {{{1

vim.g.man_hardwrap = 1

-- => perl.vim ---------------------------------------------------------------------------------------------------- {{{1

-- man: ft-perl-syntax
vim.g.perl_fold = 1
vim.g.perl_include_pod = 0
vim.g.perl_no_extended_vars = 1
vim.g.perl_no_scope_in_variables = 1
vim.g.perl_nofold_packages = 1

-- => compiler/perl.vim ------------------------------------------------------------------------------------------- {{{1

vim.g.perl_compiler_force_warnings = 0

-- => python.vim -------------------------------------------------------------------------------------------------- {{{1

vim.g.loaded_python_provider = 0
vim.g.python_host_prog = 'python'
vim.g.python3_host_prog = 'python'

-- => tmux.vim ---------------------------------------------------------------------------------------------------- {{{1

vim.g.tmux_navigator_no_mappings = 1

-- => ------------------------------------------------------------------------------------------------------------- {{{1

vim.g.markdown_recommended_style = 0

vim.g.zeal_app = 'org.zealdocs.Zeal'
