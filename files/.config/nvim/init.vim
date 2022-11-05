if exists('g:loaded_man')
  finish
endif
let g:loaded_man = 1

let g:did_install_default_menus = 1
let g:did_install_syntax_menu   = 1
let g:did_indent_on             = 1
let g:did_load_filetypes        = 1
let g:did_load_ftplugin         = 1
let g:loaded_2html_plugin       = 1
let g:loaded_gzip               = 1
let g:loaded_man                = 1
let g:loaded_matchit            = 1
let g:loaded_matchparen         = 1
let g:loaded_netrwPlugin        = 1
let g:loaded_remote_plugins     = 1
let g:loaded_shada_plugin       = 1
let g:loaded_spellfile_plugin   = 1
let g:loaded_tarPlugin          = 1
let g:loaded_tutor_mode_plugin  = 1
let g:loaded_zipPlugin          = 1
let g:skip_loading_mswin        = 1

" ----- vim-plug
" https://github.com/junegunn/vim-plug/wiki/tips#automatic-installation
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Install vim-plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

" Close quickfix list after move to file
autocmd FileType qf nnoremap <buffer> <CR> <CR>:cclose<CR>


call plug#begin()
Plug 'scrooloose/nerdtree'
Plug 'vim-denops/denops.vim'
Plug 'itchyny/lightline.vim'
Plug 'Shougo/neomru.vim'
Plug 'thinca/vim-quickrun'
Plug 'haya14busa/incsearch.vim'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'Shougo/neoyank.vim'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'cohama/lexima.vim'
Plug 'cespare/vim-toml'
Plug 'uarun/vim-protobuf'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'christoomey/vim-tmux-navigator'
Plug 'Shougo/vimproc.vim', {'do' : 'make'}
Plug 'iberianpig/tig-explorer.vim'
Plug 'liuchengxu/graphviz.vim'
Plug 'knsh14/vim-github-link'

" ddu familiy
Plug 'Shougo/ddu.vim'
Plug 'Shougo/ddu-ui-ff'
Plug 'Shougo/ddu-source-register'
Plug 'kuuote/ddu-source-mr'
Plug 'lambdalisue/mr.vim'
Plug 'shun/ddu-source-buffer'
Plug 'Shougo/ddu-filter-matcher_substring'
Plug 'Shougo/ddu-commands.vim'
Plug 'shun/ddu-source-rg'
Plug 'Shougo/ddu-kind-file'
Plug 'Shougo/ddu-source-file_rec'
Plug 'yuki-yano/ddu-filter-fzf'

call plug#end()


" ----- general settings
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

" let mapleader = "\<Space>"

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

" ----- scrooloose/nerdtree
let g:NERDTreeBookmarksFile = $HOME ."/tmp/nerdtree/bookmarks"
nnoremap <silent><C-t> :NERDTreeToggle<CR>
nnoremap <silent><C-e> :NERDTreeFind %<CR>

" ----- prabirshrestha/asyncomplete-lsp.vim
let g:lsp_text_edit_enabled = 0

" ----- 'prabirshrestha/vim-lsp'
if !exists('g:vscode')
  setlocal omnifunc=lsp#complete
  setlocal signcolumn=yes
  nmap <silent> gd <plug>(lsp-definition)
  nmap <silent> gi <plug>(lsp-implementation)
  nmap <silent> gr <plug>(lsp-references)
  nmap <silent> gt <plug>(lsp-type-definition)
  nmap <silent> K <plug>(lsp-hover)

  let g:lsp_diagnostics_enabled = 1
  let g:lsp_diagnostics_echo_cursor = 1
  let g:asyncomplete_auto_popup = 1
  let g:asyncomplete_popup_delay = 0 
  let g:lsp_text_edit_enabled = 1

  let g:lsp_format_sync_timeout = 1000
  autocmd BufWritePre *.go call execute(['LspCodeActionSync source.organizeImports', 'LspDocumentFormatSync'])
else
  nmap <silent> gd <Cmd>call VSCodeNotify('editor.action.revealDefinition')<CR>
  nmap <silent> gi <Cmd>call VSCodeNotify('editor.action.goToImplementation')<CR>
  nmap <silent> gr <Cmd>call VSCodeNotify('editor.action.referenceSearch.trigger')<CR>
  nmap <silent> K  <Cmd>call VSCodeNotify('editor.action.showHover')<CR>
endif

let lsp_signature_help_enabled = 0

" ----- mattn/vim-lsp-settings
let s:pyls_config = {'pyls': {'plugins': {
  \   'flake8': {'enabled': v:true},
  \ }}}

" ----- knsh14/vim-github-link
nmap <silent> y :GetCommitLink<CR>

" ----- Shougo/ddu.nvim
call ddu#custom#patch_global({
    \   'ui': 'ff',
    \   'uiParams': {
    \     'ff': {
    \       'startFilter': v:false,
    \       'split': 'floating',
    \       'floatingBorder': "single", 
    \       'filterSplitDirection': 'floating',
    \       'highlights': {
    \         'floating': 'Normal:BorderedFloat,Search:',
    \       }
    \     }
    \   },
    \   'sourceOptions': {
    \     '_': {
    \       'matchers': ['matcher_fzf'],
    \     },
    \   },
    \   'sourceParams' : {
    \     'rg': {'args': ['--column', '--no-heading']},
    \   },
    \   'kindOptions': {
    \     'file': {
    \       'defaultAction': 'open',
    \     },
    \   },
    \ })

call ddu#custom#patch_local('files', {
    \ 'sources': [
    \   {'name': 'file_rec', 'params': {}},
    \ ],
    \ })


"ddu-key-setting
autocmd FileType ddu-ff call s:ddu_my_settings()
function! s:ddu_my_settings() abort
  nnoremap <buffer><silent> <CR>
        \ <Cmd>call ddu#ui#ff#do_action('itemAction')<CR>
  nnoremap <buffer><silent> <Space>
        \ <Cmd>call ddu#ui#ff#do_action('toggleSelectItem')<CR>
  nnoremap <buffer><silent> i
        \ <Cmd>call ddu#ui#ff#do_action('openFilterWindow')<CR>
  nnoremap <buffer><silent> q
        \ <Cmd>call ddu#ui#ff#do_action('quit')<CR>
endfunction

autocmd FileType ddu-ff-filter call s:ddu_filter_my_settings()
function! s:ddu_filter_my_settings() abort
  inoremap <buffer><silent> <CR>
  \ <Esc><Cmd>close<CR>
  nnoremap <buffer><silent> <CR>
  \ <Cmd>close<CR>
  nnoremap <buffer><silent> q
  \ <Cmd>close<CR>
endfunction

"ddu keymapping.
nnoremap <silent> <C-u>u :<C-u>Ddu mr<CR>
nnoremap <silent> <C-p> :<C-u>call ddu#start({'name': 'files'})<CR>
nnoremap <silent> ,g <Cmd>call ddu#start({
\   'name': 'grep',
\   'sources':[
\     {'name': 'rg', 'params': {'input': input("Search: "), 'args': ["--json"]}}
\   ]
\ })<CR>
