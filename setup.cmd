@echo off

mkdir     "%USERPROFILE%\.cache"
mkdir     "%USERPROFILE%\.cache\bin"
mkdir     "%USERPROFILE%\.config"
mkdir     "%USERPROFILE%\.config\nvim"
mkdir     "%USERPROFILE%\.local"

mklink /d "%USERPROFILE%\.local\bin"                 "%~dp0.local\bin"

mklink    "%USERPROFILE%\.vimrc"                     "%~dp0.config\nvim\init.vim"
mklink /d "%USERPROFILE%\.tmux.conf"                 "%~dp0.config\tmux\config"
mklink /d "%USERPROFILE%\.ssh"                       "%~dp0.ssh"
mklink    "%USERPROFILE%\.minttyrc"                  "%~dp0.minttyrc"
mklink    "%USERPROFILE%\.zshenv"                    "%~dp0.zshenv"

mklink /d "%USERPROFILE%\.config\git"                "%~dp0.config\git"
mklink /d "%USERPROFILE%\.config\shell"              "%~dp0.config\shell"
mklink /d "%USERPROFILE%\.config\nvim\init.vim"      "%~dp0.config\nvim\init.vim"
mklink    "%USERPROFILE%\.config\nvim\plugins.vim"   "%~dp0.config\nvim\plugins.vim"
mklink /d "%USERPROFILE%\.config\tmux"               "%~dp0.config\tmux"
mklink /d "%USERPROFILE%\.config\vifm"               "%~dp0.config\vifm"
mklink /d "%USERPROFILE%\.config\zsh"                "%~dp0.config\zsh"

:quit
exit /b 0
