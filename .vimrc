set nocompatible              " be iMproved, required
filetype off                  " required

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'vimwiki/vimwiki'
Plugin 'morhetz/gruvbox'

call vundle#end()            " required
filetype plugin indent on    " required

set expandtab
set tabstop=2
set shiftwidth=2
set showmatch
set backspace=indent,eol,start
set nowrap
syn on
set completeopt=menu,longest,preview
set confirm
set number
set hlsearch
set wrap
set linebreak
set nolist
set encoding=utf-8
syntax enable

if &term =~ '256color'
  set t_ut=
endif

colorscheme gruvbox
set background=dark 

let g:vimwiki_list = [{'path': '~/dotfiles/docs/', 'syntax': 'markdown', 'ext':'.md'},{'path': '~/engagements', 'syntax': 'markdown', 'ext':'.md'}]
