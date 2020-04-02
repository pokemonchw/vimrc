call plug#begin('~/.vim/plugged') 
Plug 'vim-scripts/indentpython.vim'
Plug 'nvie/vim-flake8'
Plug 'scrooloose/nerdtree'
Plug 'luochen1990/rainbow'
Plug 'Yggdroot/indentLine'
Plug 'gmarik/Vundle.vim'
Plug 'fatih/vim-go'
Plug 'kien/rainbow_parentheses.vim'
Plug 'Yggdroot/LeaderF'
call plug#end()
nnoremap <space> za
autocmd FileType python set ai
autocmd FileType python set sw=4
autocmd FileType python set ts=4
autocmd FileType python set sts=4
autocmd FileType python set ai
autocmd FileType json set sw=2
autocmd FileType json set ts=2
autocmd FileType json set sts=2
autocmd Filetype json :IndentLinesDisable
set expandtab
set foldmethod=indent
set foldlevel=99
set nu
set mouse=a
set completeopt=popup
set t_Co=256
set encoding=utf-8
let python_highlight_all=1
let g:rainbow_active=1
let g:ycm_min_num_of_chars_for_completion=1
let g:jedi#auto_close_doc=1
let g:ycm_complete_in_comments=1
let g:ycm_complete_in_strings=1
let g:ycm_collect_identifiers_from_comments_and_strings=1
let g:ycm_collect_identifiers_from_tags_files=1
let g:ycm_semantic_triggers={'python,go': ['re!\w{1}']}
let g:go_def_mode = 'gopls'
let g:Lf_WindowPosition = 'popup'
let g:Lf_CommandMap = {'<C-K>': ['<Up>'], '<C-J>': ['<Down>']}
let g:Lf_PreviewInPopup = 1
syntax on
filetype on
filetype plugin indent on
highlight Pmenu ctermfg=15 ctermbg=8
highlight PmenuSel ctermfg=0 ctermbg=7
autocmd FileType python nnoremap <buffer> <C-]> :YcmCompleter GoToDefinitionElseDeclaration <CR>
map <F2> :NERDTreeToggle<CR>
map <F6> :PlugStatus<CR>
map <F7> :PlugInstall<CR>
map <F8> :PlugClean<CR>
map <C-f> :Leaderf rg 
