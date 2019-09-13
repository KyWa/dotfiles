set nocompatible              " be iMproved, required
filetype off                  " required

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" vundle
Plugin 'VundleVim/Vundle.vim'
" vimwiki
Plugin 'vimwiki/vimwiki'
" GruvBox
Plugin 'morhetz/gruvbox'

call vundle#end()            " required
filetype plugin indent on    " required

set expandtab
set tabstop=4
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
syntax enable

if &term =~ '256color'
  set t_ut=
endif

autocmd FileType yaml setlocal ai ts=2 sw=2 et

colorscheme gruvbox
set background=dark 

" vimwiki/vimwiki
let g:vimwiki_list = [{'path': '~/dotfiles/docs/', 'syntax': 'markdown', 'ext':'.md'}]
"let g:vimwiki_list = [{'path': '~/dotfiles/docs/', 'syntax': 'markdown', 'ext':'.md'},{'path': '~/xom/', 'syntax': 'markdown', 'ext':'.md'}]
