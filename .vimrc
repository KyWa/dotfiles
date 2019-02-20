set nocompatible              " be iMproved, required
filetype off                  " required

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" vundle
Plugin 'VundleVim/Vundle.vim'
" vimwiki
Plugin 'vimwiki/vimwiki'

call vundle#end()            " required
filetype plugin indent on    " required

set expandtab
set shiftwidth=4
set showmatch
set backspace=indent,eol,start
set nowrap
syn on
set completeopt=menu,longest,preview
set confirm
set number
set wrap
set linebreak
set nolist
set encoding=utf-8

" vimwiki/vimwiki
let g:vimwiki_list = [{'path': '~/docs/', 'syntax': 'markdown', 'ext':'.md'}]
