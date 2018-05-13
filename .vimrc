" Cheat sheet
" zz / zt - scroll to top / middle relative to position
" gt / gT / :newtab - tab
" Ctrl+O / Ctrl-I / :jumps - jump
" gU / gu  - make lower / uppercase
" ga - show ascii
" gd - go to definition
" gf - open file
" gV - reselect visual
" C-N / C-P keyword completion
" C-X C-O mega awesome omni completion
" C-X C-L complete whole line
set nobackup
set nocompatible
set shiftwidth=2
set tabstop=2
set expandtab
set softtabstop=2
set showcmd
set nowrap
set ruler
set scrolloff=10
set number
set relativenumber
set colorcolumn=81
color jellybeans

set list
set list listchars=tab:»·,trail:·,extends:…

noremap <Space> <PageDown>

syntax on
filetype on
filetype plugin on
filetype indent on

autocmd Filetype go setlocal noexpandtab

highlight TrailingSpace ctermbg=red guibg=red
:match TrailingSpace /\s\+\%#\@<!$/
