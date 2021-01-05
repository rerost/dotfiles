let s:dein_dir = expand('~/tmp/nvim/.cache/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

if &runtimepath !~# expand('~/.config/nvim/dein.vim')
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone --depth=1 https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
endif

if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  let g:rc_dir    = expand('~/.config/nvim/rc')
  let s:toml      = g:rc_dir . '/dein.toml'
  let s:lazy_toml = g:rc_dir . '/dein_lazy.toml'

  call dein#load_toml(s:toml,      {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})

  call dein#end()
  call dein#save_state()
endif

if dein#check_install()
  call dein#install()
endif


filetype plugin indent on

syntax on
set number
set tabstop=2
set shiftwidth=2
set autoindent
set hlsearch
set expandtab
set smartindent
set cursorline 
set nf=alpha 
set autoread

set statusline=%#warningmsg#
set statusline+=%*
set statusline+=%F
set statusline+=%m
set statusline+=%r
set statusline+=%h
set statusline+=%w
set statusline+=%=
set statusline+=(%l,%v)
set statusline+=[%L]
set statusline+=[%{&fileencoding}]
set statusline+=%{fugitive#statusline()}
set statusline+=[%{$USER}@%{matchstr(hostname(),'^[0-9A-Za-z_\\-]\\+')}]

set laststatus=2
set termguicolors 
set pumblend=30
set winblend=30

let mapleader = "\<Space>"

nmap <Esc><Esc> :nohl<CR>
inoremap (<Enter> ()<Left><CR><ESC><S-o>
imap jj <Esc>

" Tab like tmux
function! s:SID_PREFIX()
return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
endfunction

function! s:my_tabline()  "{{{
  let s = ''
  for i in range(1, tabpagenr('$'))
    let bufnrs = tabpagebuflist(i)
    let bufnr = bufnrs[tabpagewinnr(i) - 1]  " first window, first appears
    let no = i  " display 0-origin tabpagenr.
    let mod = getbufvar(bufnr, '&modified') ? '!' : ' '
    let title = fnamemodify(bufname(bufnr), ':t') != '' ? fnamemodify(bufname(bufnr), ':t') : "New Tab"
    let title = '[' . title . ']'
    let s .= '%'.i.'T'
    let s .= '%#' . (i == tabpagenr() ? 'TabLineSel' : 'TabLine') . '#'
    let s .= no . ':' . title
    let s .= mod
    let s .= '%#TabLineFill# '
  endfor
  let s .= '%#TabLineFill#%T%=%#TabLine#'
  return s
endfunction "}}}
let &tabline = '%!'. s:SID_PREFIX() . 'my_tabline()'

for n in range(1, 9)
  execute 'nnoremap <silent> <C-w>'.n  ':<C-u>tabnext'.n.'<CR>'
endfor

map <silent> <C-w>c :tablast <bar> tabnew<CR>
map <silent> <C-w>w :tabclose<CR>
map <silent> <C-w>n :tabnext<CR>
map <silent> <C-w>p :tabprevious<CR>

" highlight StatusLine   term=NONE cterm=NONE ctermfg=white ctermbg=blue
" lsp
set autowrite


" go to GitHub PullRequest
set rtp+=~/go/src/github.com/pocke/whichpr
nnoremap <silent> <C-g> :call whichpr#open_line()<CR>
nnoremap <Leader>b :TigBlame<CR>
