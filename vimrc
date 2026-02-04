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

" 鼠标选中和注释代码块
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

" 文件内容预览
let g:nerdtree_auto_preview_enable = 1

let g:nerdtree_preview_popup_maxlines = 200

let g:nerdtree_preview_debounce_ms = 150

let g:nerdtree_preview_popup_width = 80

let g:nerdtree_preview_syntax_map = {
      \ 'vim': 'vim',
      \ 'lua': 'lua',
      \ 'py':  'python',
      \ 'js':  'javascript',
      \ 'ts':  'typescript',
      \ 'json':'json',
      \ 'yml': 'yaml',
      \ 'yaml':'yaml',
      \ 'toml':'toml',
      \ 'md':  'markdown',
      \ 'sh':  'sh',
      \ 'bash':'sh',
      \ 'zsh': 'zsh',
      \ 'c':   'c',
      \ 'h':   'c',
      \ 'cc':  'cpp',
      \ 'cpp': 'cpp',
      \ 'hpp': 'cpp',
      \ 'go':  'go',
      \ 'rs':  'rust',
      \ }

if !has('popupwin') || !exists('*popup_create') || !exists('*popup_settext')
  finish
endif

function! s:PreviewPopupFilter(id, key) abort
  if a:key ==# "\<Esc>" || a:key ==# 'q'
    call popup_close(a:id)
    return 1
  endif
  return 0
endfunction

function! s:ClosePreviewPopup() abort
  if exists('b:nerdtree_preview_popup_id') && b:nerdtree_preview_popup_id > 0
    call popup_close(b:nerdtree_preview_popup_id)
    let b:nerdtree_preview_popup_id = 0
  endif
  if exists('b:nerdtree_preview_last_path')
    unlet b:nerdtree_preview_last_path
  endif
  if exists('b:nerdtree_preview_timer') && b:nerdtree_preview_timer > 0
    call timer_stop(b:nerdtree_preview_timer)
    let b:nerdtree_preview_timer = 0
  endif
endfunction

function! s:GetSelectedPath() abort
  if &filetype !=# 'nerdtree'
    return ''
  endif
  try
    let l:node = g:NERDTreeFileNode.GetSelected()
  catch
    return ''
  endtry
  if empty(l:node) || !has_key(l:node, 'path')
    return ''
  endif
  return l:node.path.str()
endfunction

function! s:BuildPreviewLines(path) abort
  if empty(a:path) || !filereadable(a:path)
    return []
  endif
  let l:lines = readfile(a:path, '', g:nerdtree_preview_popup_maxlines)
  call insert(l:lines, '⟦ ' . a:path . ' ⟧', 0)
  call insert(l:lines, '', 1)
  return l:lines
endfunction

function! s:GetNERDTreePosition() abort
  let l:nerdtree_winnr = winnr()
  let l:nerdtree_width = winwidth(l:nerdtree_winnr)
  return {
        \ 'line': 1,
        \ 'col': l:nerdtree_width + 2,
        \ 'pos': 'topleft',
        \ }
endfunction

function! s:EnsurePopup() abort
  if exists('b:nerdtree_preview_popup_id') && b:nerdtree_preview_popup_id > 0
    return
  endif
  let l:pos = s:GetNERDTreePosition()
  let l:available_width = &columns - (winwidth(winnr()) + 2)
  let l:popup_width = min([g:nerdtree_preview_popup_width, l:available_width])
  let b:nerdtree_preview_popup_id = popup_create([''], #{
        \ title: 'Preview',
        \ line: l:pos.line,
        \ col: l:pos.col,
        \ pos: l:pos.pos,
        \ border: [],
        \ padding: [0,1,0,1],
        \ wrap: v:true,
        \ scrollbar: 1,
        \ fixed: v:true,
        \ minwidth: l:popup_width,
        \ maxwidth: l:popup_width,
        \ maxheight: &lines - 4,
        \ close: 'click',
        \ mapping: v:true,
        \ filter: function('s:PreviewPopupFilter'),
        \ })
endfunction

function! s:RefreshPreviewNow() abort
  if !get(g:, 'nerdtree_auto_preview_enable', 1)
    return
  endif
  if &filetype !=# 'nerdtree'
    return
  endif
  let l:path = s:GetSelectedPath()
  if empty(l:path) || !filereadable(l:path)
    call s:ClosePreviewPopup()
    return
  endif
  if exists('b:nerdtree_preview_last_path') && b:nerdtree_preview_last_path ==# l:path
    call s:UpdatePopupPosition()
    return
  endif
  let b:nerdtree_preview_last_path = l:path
  call s:ClosePreviewPopup()
  call s:EnsurePopup()
  let l:content = s:BuildPreviewLines(l:path)
  if empty(l:content)
    call s:ClosePreviewPopup()
    return
  endif
  call popup_settext(b:nerdtree_preview_popup_id, l:content)
  call s:ApplyPopupSyntax(l:path)
endfunction

function! s:UpdatePopupPosition() abort
  if !exists('b:nerdtree_preview_popup_id') || b:nerdtree_preview_popup_id <= 0
    return
  endif
  let l:pos = s:GetNERDTreePosition()
  let l:available_width = &columns - (winwidth(winnr()) + 2)
  let l:popup_width = min([g:nerdtree_preview_popup_width, l:available_width])
  call popup_move(b:nerdtree_preview_popup_id, #{
        \ line: l:pos.line,
        \ col: l:pos.col,
        \ pos: l:pos.pos,
        \ minwidth: l:popup_width,
        \ maxwidth: l:popup_width,
        \ })
endfunction

function! s:ApplyPopupSyntax(path) abort
  if !exists('b:nerdtree_preview_popup_id') || b:nerdtree_preview_popup_id <= 0
    return
  endif
  let l:winid = b:nerdtree_preview_popup_id
  let l:bufnr = winbufnr(l:winid)
  if l:bufnr <= 0
    return
  endif
  call win_execute(l:winid, 'setlocal buftype=nofile bufhidden=wipe nobuflisted')
  call win_execute(l:winid, 'setlocal noswapfile wrap')
  call win_execute(l:winid, 'setlocal foldmethod=manual nofoldenable')
  call win_execute(l:winid, 'setlocal linebreak')
  call win_execute(l:winid, 'setlocal breakindent')
  call win_execute(l:winid, 'setlocal number')

  let l:syn = s:DetectSyntaxByExt(a:path)
  if !empty(l:syn)
    call win_execute(l:winid, 'setlocal syntax=' . l:syn)
    call win_execute(l:winid, 'setlocal filetype=' . l:syn)
  else
    call win_execute(l:winid, 'setlocal syntax=OFF')
    call win_execute(l:winid, 'setlocal filetype=')
  endif
endfunction

function! s:DebouncedRefresh() abort
  if !get(g:, 'nerdtree_auto_preview_enable', 1)
    return
  endif
  if &filetype !=# 'nerdtree'
    return
  endif
  if exists('b:nerdtree_preview_timer') && b:nerdtree_preview_timer > 0
    call timer_stop(b:nerdtree_preview_timer)
  endif
  let b:nerdtree_preview_timer = timer_start(
        \ g:nerdtree_preview_debounce_ms,
        \ {-> execute('call <SID>RefreshPreviewNow()')})
endfunction

function! s:AttachNERDTreeAutoPreview() abort
  if exists('b:nerdtree_auto_preview_attached')
    return
  endif
  let b:nerdtree_auto_preview_attached = 1
  autocmd CursorMoved <buffer> call <SID>DebouncedRefresh()
  autocmd BufLeave,WinLeave <buffer> call <SID>ClosePreviewPopup()
  autocmd BufEnter * call <SID>ClosePreviewOnFileOpen()
  call <SID>DebouncedRefresh()
endfunction

augroup NERDTreeAutoPreviewPopup
  autocmd!
  autocmd FileType nerdtree call <SID>AttachNERDTreeAutoPreview()
augroup END

command! NERDTreePreviewToggle let g:nerdtree_auto_preview_enable = !get(g:, 'nerdtree_auto_preview_enable', 1)

function! s:DetectSyntaxByExt(path) abort
  let l:ext = tolower(fnamemodify(a:path, ':e'))
  if empty(l:ext)
    return ''
  endif
  return get(g:nerdtree_preview_syntax_map, l:ext, '')
endfunction

function! s:ClosePreviewOnFileOpen() abort
  if &filetype !=# 'nerdtree'
    for l:winnr in range(1, winnr('$'))
      if getwinvar(l:winnr, '&filetype') ==# 'nerdtree'
        let l:bufnr = winbufnr(l:winnr)
        let l:popup_id = getbufvar(l:bufnr, 'nerdtree_preview_popup_id', 0)
        if l:popup_id > 0
          call popup_close(l:popup_id)
          call setbufvar(l:bufnr, 'nerdtree_preview_popup_id', 0)
        endif
      endif
    endfor
  endif
endfunction
