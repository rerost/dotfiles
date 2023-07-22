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

highlight Pmenu ctermbg=black guibg=black

" ----- vim-plug
" https://github.com/junegunn/vim-plug/wiki/tips#automatic-installation

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
Plug 'itchyny/lightline.vim'
Plug 'git@github.com:scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'cohama/lexima.vim'
Plug 'christoomey/vim-tmux-navigator'

Plug 'dstein64/vim-startuptime'

" Base
Plug 'vim-denops/denops.vim'

" lsp
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'liuchengxu/vista.vim'

" git
Plug 'knsh14/vim-github-link'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'Xuyuanp/nerdtree-git-plugin'

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

set autowrite

" ----- scrooloose/nerdtree
let g:NERDTreeBookmarksFile = $HOME ."/tmp/nerdtree/bookmarks"
nnoremap <silent><C-t> :NERDTreeToggle<CR>
nnoremap <silent><C-e> :NERDTreeFind %<CR>
let g:NERDTreeHijackNetrw = 0

" ----- airblade/vim-gitgutter
let g:gitgutter_highlight_lines = 1

" ----- prabirshrestha/asyncomplete-lsp.vim
let g:lsp_text_edit_enabled = 0

" ----- 'prabirshrestha/vim-lsp'
setlocal omnifunc=lsp#complete
setlocal signcolumn=yes
nmap <silent> gd <plug>(lsp-definition)
nmap <silent> gi <plug>(lsp-implementation)
nmap <silent> gr <plug>(lsp-references)
nmap <silent> gt <plug>(lsp-type-definition)
nmap <silent> gn <plug>(lsp-rename)
nmap <silent> K <plug>(lsp-hover)
nmap <silent> . :LspCodeAction<CR>

let g:lsp_diagnostics_enabled = 1
let g:lsp_diagnostics_echo_cursor = 1
let g:asyncomplete_auto_popup = 1
let g:asyncomplete_popup_delay = 0 
let g:lsp_text_edit_enabled = 1

let g:lsp_format_sync_timeout = 1000
autocmd BufWritePre *.go call execute(['LspCodeActionSync source.organizeImports', 'LspDocumentFormatSync'])

let lsp_signature_help_enabled = 0
let g:lsp_inlay_hints_enabled = 1

" -- debug lsp
" let g:lsp_log_verbose = 1
" let g:lsp_log_file = expand('~/vim-lsp.log')
"
" -- debug for gopls
" let g:lsp_settings = {
"       \ 'gopls': { 'args': ["-logfile=/Users/hazumi/goplslog", "-rpc.trace", "--debug=localhost:6060"] }
"       \ }

" ----- mattn/vim-lsp-settings
let g:lsp_settings_filetype_typescript = ['typescript-language-server', 'eslint-language-server']
let g:lsp_settings_filetype_typescriptreact = ['typescript-language-server', 'eslint-language-server']

"  ----- liuchengxu/vista.vim
let g:vista_default_executive="vim_lsp"
function! NearestMethodOrFunction() abort
  return get(b:, 'vista_nearest_method_or_function', '')
endfunction
let g:vista_sidebar_width=50

let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'readonly', 'filename', 'modified', 'method' ] ]
      \ },
      \ 'component_function': {
      \   'method': 'NearestMethodOrFunction'
      \ },
      \ }

" MEMO: Vscode は Cmd + Shift + o
nmap <silent> <Leader>o :Vista!!<CR>

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
    \   {'name': 'file_rec', 'params': {"ignoredDirectories": ["dist", "node_modules"]}},
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


" ----- lambdalisue/mr.vim
" Disable git master -> main warning
let g:mr_disable_warning = 1
