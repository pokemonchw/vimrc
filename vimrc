call plug#begin('~/.vim/plugged') 
Plug 'vim-scripts/indentpython.vim'
Plug 'Valloric/YouCompleteMe'
Plug 'nvie/vim-flake8'
Plug 'scrooloose/nerdtree'
Plug 'luochen1990/rainbow'
Plug 'Yggdroot/indentLine'
Plug 'gmarik/Vundle.vim'
Plug 'fatih/vim-go'
Plug 'kien/rainbow_parentheses.vim'
Plug 'Yggdroot/LeaderF'
call plug#end()
filetype on
filetype plugin indent on
colorscheme slate
autocmd FileType go let g:go_def_mode = 'gopls'
autocmd FileType cpp nnoremap <buffer> <C-]> :YcmCompleter GoToDefinitionElseDeclaration <CR>
autocmd FileType python set ai
autocmd FileType python set sw=4
autocmd FileType python set ts=4
autocmd FileType python set sts=4
autocmd FileType python set ai
autocmd FileType python map <buffer> <F3> :call flake8#Flake8()<CR>
autocmd FileType python nnoremap <buffer> <C-]> :YcmCompleter GoToDefinitionElseDeclaration <CR>
autocmd FileType python nnoremap <buffer> <C-\> :vsp \| :YcmCompleter GoToDefinitionElseDeclaration <CR>
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
let g:ycm_semantic_triggers={'python,go,cpp': ['re!\w{2}']}
let g:Lf_WindowPosition = 'popup'
let g:Lf_CommandMap = {'<C-K>': ['<Up>'], '<C-J>': ['<Down>']}
let g:Lf_PreviewInPopup = 1
let g:ycm_global_ycm_extra_conf = '~/.vim/plugged/YouCompleteMe/.ycm_extra_conf.py'
syntax on
highlight Pmenu ctermfg=15 ctermbg=236
highlight PmenuSel ctermfg=0 ctermbg=7
map <F2> :NERDTreeToggle<CR>
map <F6> :PlugStatus<CR>
map <F7> :PlugInstall<CR>
map <F8> :PlugClean<CR>
map <C-f> :Leaderf rg --sort path -M 200 
map <C-left> ^
map <C-right> $
map <C-up> B
map <C-down> W

function! s:ToggleBlockCommentVisual() range
  let l:start_line = line("'<")
  let l:end_line   = line("'>")

  if l:start_line > l:end_line
    let l:tmp = l:start_line
    let l:start_line = l:end_line
    let l:end_line = l:tmp
  endif

  if &filetype ==# 'python'
    let l:begin = '"""'
    let l:end   = '"""'
  elseif &filetype ==# 'go'
    let l:begin = '/*'
    let l:end   = '*/'
  else
    echo "当前文件类型不支持块注释：" . &filetype
    return
  endif

  let l:prev_line = getline(l:start_line - 1)
  let l:next_line = getline(l:end_line + 1)

  let l:prev_trim = trim(l:prev_line)
  let l:next_trim = trim(l:next_line)

  if l:prev_trim ==# l:begin && l:next_trim ==# l:end
    call deletebufline(bufnr('%'), l:end_line + 1)
    call deletebufline(bufnr('%'), l:start_line - 1)
  else
    call append(l:end_line, l:end)
    call append(l:start_line - 1, l:begin)
  endif
endfunction

xnoremap <silent> # :<C-u>call <SID>ToggleBlockCommentVisual()<CR>
