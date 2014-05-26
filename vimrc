scriptencoding utf8

"neobundle(https://github.com/Shougo/neobundle.vim.git)
set nocompatible              " Be Improved
if has('vim_starting')
  set rtp+=~/.vim/neobundle.vim/
endif
call neobundle#rc(expand('~/.vim/bundle/'))

" NeoBundles {{{
NeoBundle 'Shougo/vimshell.git'
NeoBundle 'Shougo/vimproc.git' , {
              \ 'build' : {
              \     'windows' : 'echo "Sorry, cannot update vimproc."',
              \     'cygwin' : 'make -f make_cygwin.mak',
              \     'mac' : 'make -f make_mac.mak',
              \     'unix' : 'make -f make_unix.mak',
              \    },
              \ }
NeoBundle 'Shougo/unite.vim'
NeoBundle 'sudo.vim'
NeoBundle 'Shougo/neocomplcache'
NeoBundle 'Shougo/neosnippet'
NeoBundle 'ompugao/ros.vim'
"NeoBundle "kien/ctrlp.vim"
"NeoBundle "ompugao/ctrlp-ros"
"}}}

" 文字コード関連  {{{
if &encoding !=# 'utf-8'
	set encoding=japan
	set fileencoding=japan
endif
if has('iconv')
	let s:enc_euc = 'euc-jp'
	let s:enc_jis = 'iso-2022-jp'
	" iconvがeucJP-msに対応しているかをチェック
	if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
		let s:enc_euc = 'eucjp-ms'
		let s:enc_jis = 'iso-2022-jp-3'
	" iconvがJISX0213に対応しているかをチェック
	elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
		let s:enc_euc = 'euc-jisx0213'
		let s:enc_jis = 'iso-2022-jp-3'
	endif
	" fileencodingsを構築
	if &encoding ==# 'utf-8'
		let s:fileencodings_default = &fileencodings
		let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
		let &fileencodings = &fileencodings .','. s:fileencodings_default
		unlet s:fileencodings_default
	else
		let &fileencodings = &fileencodings .','. s:enc_jis
		set fileencodings+=utf-8,ucs-2le,ucs-2
		if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
			set fileencodings+=cp932
			set fileencodings-=euc-jp
			set fileencodings-=euc-jisx0213
			set fileencodings-=eucjp-ms
			let &encoding = s:enc_euc
			let &fileencoding = s:enc_euc
		else
			let &fileencodings = &fileencodings .','. s:enc_euc
		endif
	endif
	" 定数を処分
	unlet s:enc_euc
	unlet s:enc_jis
endif
" 日本語を含まない場合は fileencoding に encoding を使うようにする
if has('autocmd')
	function! AU_ReCheck_FENC()
		if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
			let &fileencoding=&encoding
		endif
	endfunction
	autocmd BufReadPost * call AU_ReCheck_FENC()
endif
" 改行コードの自動認識
set fileformats=unix,dos,mac
" □とか○の文字があってもカーソル位置がずれないようにする
if exists('&ambiwidth')
	set ambiwidth=double
endif
"}}}

" settings {{{
if has("autocmd")
	" カーソル位置を記憶する
	autocmd BufReadPost *
				\ if line("'\"") > 0 && line("'\"") <= line("$") |
				\   exe "normal g`\"" |
				\ endif
endif
" erase highlight
if has('unix') && !has('gui_running')
    inoremap <silent> <Esc> <Esc>
    inoremap <silent> <C-[> <Esc>
endif

set autoindent  " 自動インデント
set backup  " バックアップを有効にする
set backupdir=$HOME/.vimbackup  " バックアップ用ディレクトリ
if !isdirectory(&backupdir)
    call mkdir(&backupdir, "p")
endif
"set list  " 不可視文字の表示
"set listchars=tab:>\  " 不可視文字の表示方法
"set listchars=tab:»-,eol:↲,extends:»,precedes:«,nbsp:%
set showcmd  " コマンドを表示
set laststatus=2 " ステータスラインを表示
"set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%{fugitive#statusline()}\ %l,%c%V%8P " ステータスラインにファイル名・文字コード・改行形式を表示
set syntax=on  " 構文配色
set smarttab   "use shiftwidth when inserts <tab>
set expandtab  " タブをスペースに展開
set incsearch  "incremental search
set wrap  "長い行を折り返し
syntax enable  " 構文配色を有効にする
set tabline=%!MakeTabLine()"{{{
function! s:tabpage_label(n)
  " タブページ内のバッファのリスト
  let bufnrs = tabpagebuflist(a:n)

  " カレントタブページかどうかでハイライトを切り替える
  let hi = a:n is tabpagenr() ? '%#TabLineSel#' : '%#TabLine#'

  " バッファが複数あったらバッファ数を表示
  let no = len(bufnrs)
  if no is 1
    let no = ''
  endif
  " タブページ内に変更ありのバッファがあったら '+' を付ける
  let mod = len(filter(copy(bufnrs), 'getbufvar(v:val, "&modified")')) ? '+' : ''

  " カレントバッファ
  let curbufnr = bufnrs[tabpagewinnr(a:n) - 1]  " tabpagewinnr() は 1 origin
  let fname = pathshorten(bufname(curbufnr))
  if fname == ''
      let fname = '(^^)'
  endif
  let label = ' ' . no . mod . fname . ' '

  return '%' . a:n . 'T' . hi . label . '%T%#TabLineFill#'
endfunction
function! MakeTabLine()
  let titles = map(range(1, tabpagenr('$')), 's:tabpage_label(v:val)')
  let sep = ''  " タブ間の区切り
  let tabpages = join(titles, sep) . sep . '%#TabLineFill#%T'
  let info = fnamemodify(getcwd(), ":~") . ' '
  return tabpages . '%=' . info  " タブリストを左に、情報を右に表示
endfunction
"}}}
set vb t_vb= "disable visualbell
set virtualedit+=block "矩形選択で自由に移動
set clipboard+=unnamed "無名レジスタだけでなく、*レジスタにもヤンク
set matchpairs=(:),{:},[:],<:>
set backspace=indent,eol,start "help i_backspacing
set history=10000
" folding {{{
set foldenable
set foldmethod=marker
autocmd BufNewFile,BufRead *.l setlocal commentstring=\;%s
autocmd BufNewFile,BufRead *.py setlocal commentstring=\ \#%s
autocmd BufNewFile,BufRead *.rb setlocal commentstring=\ \#%s
autocmd BufNewFile,BufRead *.mkd setlocal commentstring=\ <!--\ %s\ -->
"set foldcolumn=3
"}}}
" set filetypes {{{
au BufNewFile,BufRead *.thtml setfiletype php
au BufNewFile,BufRead *.ctp setfiletype php
au BufNewFile,BufRead *.c setfiletype c
au BufNewFile,BufRead *.py setfiletype python
au BufNewFile,BufRead *.rb setfiletype ruby
au BufNewFile,BufRead *.launch setfiletype xml
au BufNewFile,BufRead *.page set filetype=markdown
au BufNewFile,BufRead *.l set ft=lisp
"}}}
" 配色設定"{{{
let g:netrw_liststyle = 3 "netrw(Explorer)を常にツリー表示する
let lisp_rainbow = 1 "lispをcolorfulに
"}}}
"}}}

command! Roseus :VimShellInteractive roseus

"neocomplcache {{{
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplcache.
let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" Use camel case completion.
let g:neocomplcache_enable_camel_case_completion = 1
" Use underbar completion.
let g:neocomplcache_enable_underbar_completion = 1
" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

" Define dictionary.
let g:neocomplcache_dictionary_filetype_lists = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist'
    \ }
    
" Define keyword.
if !exists('g:neocomplcache_keyword_patterns')
    let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'
" Plugin key-mappings.
inoremap <expr><C-g>     neocomplcache#undo_completion()
inoremap <expr><C-l>     neocomplcache#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <expr><CR>  neocomplcache#smart_close_popup() . "\<CR>"
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplcache#close_popup()
inoremap <expr><C-e>  neocomplcache#cancel_popup()


" AutoComplPop like behavior.
"let g:neocomplcache_enable_auto_select = 1

" Shell like behavior(not recommended).
"set completeopt+=longest
"let g:neocomplcache_enable_auto_select = 1
"let g:neocomplcache_disable_auto_complete = 1
"inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"
"inoremap <expr><CR>  neocomplcache#smart_close_popup() . "\<CR>"

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
if !exists('g:neocomplcache_omni_patterns')
    let g:neocomplcache_omni_patterns = {}
endif
let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
"autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.c = '\%(\.\|->\)\h\w*'
let g:neocomplcache_omni_patterns.cpp = '\h\w*\%(\.\|->\)\h\w*\|\h\w*::'
"}}}
" neosnippet {{{
" snippetの配置場所
let g:neosnippet#snippets_directory='~/.vim/snippets'
set completeopt-=preview
" Plugin key-mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)
"xmap <C-l>     <Plug>(neosnippet_start_unite_snippet_target)

"<TAB>でスニペット補完 
imap <expr><TAB> neosnippet#expandable() ? "\<Plug>(neosnippet_jump_or_expand)" : pumvisible() ? "\<C-n>" : "\<TAB>" 
"スニペットで単語が選択されている場合でも <Tab> で次のプレースホルダへ移動する 
vmap <expr><TAB> neosnippet#expandable() ?  \<Plug>(neosnippet_jump_or_expand)" : "\<Tab>"

" SuperTab like snippets behavior.
"imap <expr><TAB> neosnippet#expandable() ?
" \ "\<Plug>(neosnippet_expand_or_jump)"
" \: pumvisible() ? "\<C-n>" : "\<TAB>"
"smap <expr><TAB> neosnippet#expandable() ?
" \ "\<Plug>(neosnippet_expand_or_jump)"
" \: "\<TAB>"

" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif

" }}}
" visual comment {{{
" description : {{{
" http://labs.timedia.co.jp/2012/10/vim-more-useful-blockwise-insertion.html
" paragraphのcomment outが
" 1. vip で選択し、
" 2. I# <Esc>
" でできる }}}
vnoremap <expr> I  <SID>force_blockwise_visual('I')
vnoremap <expr> A  <SID>force_blockwise_visual('A')

function! s:force_blockwise_visual(next_key)
    if mode() ==# 'v'
        return "\<C-v>" . a:next_key
    elseif mode() ==# 'V'
        return "\<C-v>0o$" . a:next_key
    else  " mode() ==# "\<C-v>"
        return a:next_key
    endif
endfunction
"}}}

filetype plugin indent on "this line must be set to the last of .vimrc.
imap <c-j> <esc>
