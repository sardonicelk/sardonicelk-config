
call plug#begin('~/.vim/plugged')
Plug 'liuchengxu/vim-which-key'
call plug#end()


" Use the internal diff if available.
" Otherwise use the special 'diffexpr' for Windows.
if &diffopt !~# 'internal'
  set diffexpr=MyDiff()
endif

function MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg1 = substitute(arg1, '!', '\!', 'g')
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg2 = substitute(arg2, '!', '\!', 'g')
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  let arg3 = substitute(arg3, '!', '\!', 'g')
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      if empty(&shellxquote)
        let l:shxq_sav = ''
        set shellxquote&
      endif
      let cmd = '"' . $VIMRUNTIME . '\diff"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  let cmd = substitute(cmd, '!', '\!', 'g')
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3
  if exists('l:shxq_sav')
    let &shellxquote=l:shxq_sav
  endif
endfunction


" Move a window between tabs
function MoveWindowToTab(winid, to_tabnr) abort
    let from_winid = a:winid
    let buf_ref = winbufnr(from_winid)
    let from_tabnr = win_id2tabwin(from_winid)[0]
    let max_tabnr = tabpagenr('$')

    if a:to_tabnr == from_tabnr
        return
    endif

if buf_ref <= 0 || from_tabnr == 0
    echoerr 'Invalid window ID'
    return
endif

if a:to_tabnr <= 0
    0tabnew
elseif a:to_tabnr > max_tabnr
    $tabnew
else
    execute 'tabnext ' . a:to_tabnr
    execute 'belowright sbuffer ' . buf_ref
endif

let to_winid = win_getid()

if to_winid == from_winid
    return
endif

if win_id2win(from_winid) != 0
    call win_gotoid(from_winid)
    close
endif

call win_gotoid(to_winid)
endfunction


set nocompatible
set encoding=utf-8

" Try these encodings when opening files
set fileencodings=utf-8,latin1

" Set default line endings (try order)
set fileformats=unix,dos

" Don't beep
set noerrorbells
set novisualbell
set t_vb=

" Syntaxinställningar
syntax on
filetype plugin indent on

" Code folding
set foldmethod=syntax

" Wild
set wildmenu
set wildoptions=pum
set pumheight=20
set wildmode=noselect:lastused,full
set wildignorecase
autocmd CmdlineChanged [:\/\?] call wildtrigger()

set wrap
set linebreak
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set smartindent

" Better completion menu
set completeopt=menuone,noinsert,noselect

" ─────────────────────────────────────────────
" Leader key mappings
" ─────────────────────────────────────────────

let mapleader = " "
set timeoutlen=0

" Trigger which-key in normal and visual modes
nnoremap <silent> <leader> :<C-U>WhichKey '<Space>'<CR>
vnoremap <silent> <leader> :<C-U>WhichKeyVisual '<Space>'<CR>

" Buffers
nnoremap <leader>bn :new<CR>
nnoremap <leader>bl :buffers<CR>
nnoremap <leader>bj :bnext<CR>
nnoremap <leader>bk :bprevious<CR>
nnoremap <leader>bd :bdelete<CR>

" Tabs
nnoremap <leader>tn :tabnew<CR>
nnoremap <leader>tl :tabs<CR>
nnoremap <leader>tj :tabnext<CR>
nnoremap <leader>tk :tabprevious<CR>
nnoremap <leader>tc :tabclose<CR>
nnoremap <leader>to :tabonly<CR>

" Windows
nnoremap <leader>sv :vsplit<CR>
nnoremap <leader>sh :split<CR>
nnoremap <leader>so :only<CR>

" File explorer
nnoremap <leader>e :Explore!<CR>
nnoremap <leader>E :Explore! .<CR>

function! GrepPrompt() abort
    let l:pattern = input('Search: ')
    if empty(l:pattern)
        return
    endif

    execute 'vimgrep /' . escape(l:pattern, '/') . '/j **/*'
    copen
endfunction

nnoremap <leader>fg :call GrepPrompt()<CR>

" Follow link
nnoremap <leader><enter> <C-]>

" Quick navigation
nnoremap <leader>h 0
nnoremap <leader>l $l
nnoremap <leader>j L
nnoremap <leader>k H

" Quickref
nnoremap <leader>? :help quickref<CR>

" ─────────────────────────────────────────────
" Nagivation and Splits
" ─────────────────────────────────────────────

" EOL remap
nnoremap € $

" Keep cursor centered while scrolling
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
nnoremap n nzzzv
nnoremap N Nzzzv

" Splits
set splitbelow
set splitright

nnoremap <leader>t1 1gt
nnoremap <leader>t2 2gt
nnoremap <leader>t3 3gt
nnoremap <leader>t4 4gt
nnoremap <leader>t5 5gt
nnoremap <leader>t9 :tablast<CR>
nnoremap <leader>t0 :tabfirst<CR>

" Move window to tab
nnoremap <silent> <leader>t! :call MoveWindowToTab(win_getid(), 1)<CR>
nnoremap <silent> <leader>t" :call MoveWindowToTab(win_getid(), 2)<CR>
nnoremap <silent> <leader>t# :call MoveWindowToTab(win_getid(), 3)<CR>
nnoremap <silent> <leader>t€ :call MoveWindowToTab(win_getid(), 4)<CR>
nnoremap <silent> <leader>t% :call MoveWindowToTab(win_getid(), 5)<CR>
nnoremap <silent> <leader>t) :call MoveWindowToTab(win_getid(), 9)<CR>
nnoremap <silent> <leader>t= :call MoveWindowToTab(win_getid(), 0)<CR>

" Resize splits
nnoremap <leader>Up <C-w>+
nnoremap <leader>Down <C-w>-
nnoremap <leader>Left <C-w><
nnoremap <leader>Right <C-w>>

" Quit (q window / q Vim)
function! CloseWindowOrQuit()
    if winnr('$') > 1
        close
    else
        quit
    endif
endfunction

nnoremap <C-q> :call CloseWindowOrQuit()<CR>

" ─────────────────────────────────────────────
" Editing
" ─────────────────────────────────────────────

" jk acts as Escape in insert mode
inoremap jk <Esc>

" Faster save
nnoremap <leader>w :write<CR>

" Faster quit
nnoremap <leader>q :quit<CR>

" ─────────────────────────────────────────────
" Clipboard
" ─────────────────────────────────────────────

" Use system clipboard
set clipboard+=unnamed

" ─────────────────────────────────────────────
" Misc
" ─────────────────────────────────────────────

" Show invisible whitespace
set list
set listchars=tab:→\ ,trail:·,nbsp:␣

" Backspace fix
set backspace=indent,eol,start

" Ett steg längre än sista tecken på en rad
set virtualedit=onemore

" ─────────────────────────────────────────────
" Appearance
" ─────────────────────────────────────────────
set laststatus=2
set number relativenumber
set cursorline

" Statusbar
set statusline=
set statusline+=%f
set statusline+=\ %m%r
set statusline+=\ \ [%{&filetype}]
set statusline+=\ \ %{&fileencoding!=''?&fileencoding:&encoding}
set statusline+=\ \ %l/%L:%c\ %p%%

" Search
set hlsearch
nnoremap <silent> <Esc> :nohlsearch<CR>
" incremental search
set incsearch
set ignorecase
set smartcase

colorscheme habamax

