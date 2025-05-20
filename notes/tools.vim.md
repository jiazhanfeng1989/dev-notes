---
id: qn1kf0wx67e9u8wzfhyz2px
title: Vim
desc: 'vim useful config'
updated: 1747734113703
created: 1747734012646
---

# vim useful config
```
set nocompatible
syntax on
set number
set cursorline
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent
set smartindent
set wrap
set linebreak
set showmatch
set incsearch
set ignorecase
set smartcase
set mouse=a
set clipboard=unnamed
set laststatus=2
set ruler
set showcmd
set nobackup
set nowritebackup
set noswapfile
nnoremap <C-s> :w<CR>
inoremap <C-s> <Esc>:w<CR>
vnoremap <C-c> "+y
nnoremap <C-c> "+y$
filetype plugin indent on
```