" vim configuration maintainer: PokeyBoa

" Configuration file for vim
set modelines=0                   " CVE-2007-2438

" Normally we use vim-extensions. If you want true vi-compatibility remove change the following statements
set nocompatible                  " Use Vim defaults instead of 100% vi compatibility
set backspace=2                   " More powerful backspacing

" Skip defaults vim
let skip_defaults_vim=1

" Syntax highlighting
syntax on

" Show line number
set nu

" Define the length of the tab to 4
set tabstop=4

" Do not backup when overwriting files
set nobackup

" Highlight the current line
set cursorline

" High brightness
set hlsearch

" Display the current mode status in the lower left corner
set showmode

" In a terminal emulator like konsole or gnome-terminal, you should to set a 256 color setting for vim
set t_Co=256

" Display different background color tones
set bg=dark

" Display the status line at the cursor position in the lower right corner
set ruler

" Auto indent
set autoindent

" Enter paste mode
set paste

" Language and encoding
set encoding=utf-8
set termencoding=utf-8
set fileencoding=chinese
set fileencodings=ucs-bom,utf-8,chinese
set langmenu=zh_CN,utf-8
