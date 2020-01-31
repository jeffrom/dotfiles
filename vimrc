" slightly more minimal vimrc

if has('python3')
    silent! python3 1
endif

call pathogen#infect('bundle/{}')

syntax enable
filetype plugin indent on
set modeline
set tabstop=4
set shiftwidth=4
" set tabstop=2
" set shiftwidth=2
set expandtab
set nosmartindent  " plugin indent on seems to do a better job
set hidden
set ruler
set concealcursor="nc"
let g:netrw_banner=0

runtime macros/matchit.vim
" because os x is dumb
set backspace=indent,eol,start

" open splits on the right
set splitright
set incsearch
set ignorecase
set smartcase

" backup file locations
set backup
set backupdir=~/.vim/backup
set directory=~/.vim/backup
if has('persistent_undo')
    set undofile
    set undodir=~/.vim/backup
endif

set wildmenu
" set wildmode=list:full
set wildmode=list:longest

" stay three lines from the bottom
set scrolloff=3

let g:jellybeans_overrides = {
\    'background': { 'guibg': '000000' },
\}

" let g:dues_contrast_dark = 'hard'

colorscheme jellybeans
" colorscheme dues

hi QuickFixLine ctermbg=blue

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
autocmd BufReadPost *
\ if line("'\"") > 0 && line("'\"") <= line("$") |
\   exe "normal g`\"" |
\ endif

" When opening a new file, use a skeleton to get started
autocmd! BufNewFile * silent! 0r ~/.vim/skeleton.%:e

" Don't delete trailing whitespace for these filetypes
autocmd FileType snippets :let b:notrailing=1

" autocmd BufRead,BufNewFile *.json set filetype=javascript
autocmd BufRead,BufNewFile *.html set filetype=html
autocmd BufRead,BufNewFile .jshintrc set filetype=javascript
autocmd BufRead,BufNewFile .sgconf set filetype=yaml
autocmd BufRead,BufNewFile Jenkinsfile set filetype=groovy
autocmd BufRead,BufNewFile *.jenkinsfile set filetype=groovy
autocmd BufRead,BufNewFile Jenkinsfile.* set filetype=groovy
autocmd BufRead,BufNewFile mix.lock set filetype=elixir

autocmd FileType html,javascript,mustache,stylus,typescript,ruby,groovy,yaml,qtpl setlocal shiftwidth=2 tabstop=2
autocmd FileType php setlocal commentstring=//\ %s

" Delete trailing whitespace on save
fun! StripTrailingWhitespace()
    if exists("b:notrailing")
        return
    endif
    %s/\s\+$//e
endfun
autocmd BufWritePre * :call StripTrailingWhitespace()

" nice
imap jj <ESC>
nnoremap ; :

" leader key
let mapleader=","

" improve switching windows (append "<C-W>_" to each line to flatten)
map <C-J> <C-W>j
map <C-K> <C-W>k
map <C-L> <C-W>l
map <C-H> <C-W>h

" make Y consistent with C and D
nnoremap Y y$

" Omni complete to override mustache
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags

" Toggle highlight when <leader><leader> is pressed
map <silent> <leader><leader> :set hlsearch! hlsearch?<CR>

" Underline the current line with dashes in normal mode
nnoremap <leader>_ yyp<c-v>$r-

" Align regexp
command! -nargs=? -range Align <line1>,<line2>call AlignSection('<args>')
vnoremap <silent> <Leader>a :Align<CR>

" spell check
map <silent> <leader>s :setlocal spell! spell? spelllang=en_us<CR>

map <silent> <leader>p :set invpaste paste?<CR>
map <silent> <leader><tab> :setlocal et! et?<CR>
map <silent> <leader>d :Gdiff<CR>

" quote selection/word under cursor
map <silent> <leader>'W ciW'<C-R>"'<ESC>
map <silent> <leader>"W ciW"<C-R>""<ESC>
map <silent> <leader>'w ciw'<C-R>"'<ESC>
map <silent> <leader>"w ciw"<C-R>""<ESC>
map <silent> <leader>(w ciw(<C-R>")<ESC>
map <silent> <leader>(W ciW(<C-R>")<ESC>
map <silent> <leader>(% c%(<C-R>")<ESC>
map <silent> <leader>)w ciw(<C-R>")<ESC>
map <silent> <leader>)W ciW(<C-R>")<ESC>
map <silent> <leader>)% c%(<C-R>")<ESC>
map <silent> <leader>"$ $i"<ESC>
map <silent> <leader>)$ $i)<ESC>

vmap <silent> <leader>' c'<C-R>"'<ESC>
vmap <silent> <leader>" c"<C-R>""<ESC>
vmap <silent> <leader>( c(<C-R>")<ESC>
vmap <silent> <leader>) c(<C-R>")<ESC>

" workaround for vim 7.4 so :E works correctly
" let g:loaded_logipat = 1
command! E Explore

" ctrlP
set wildignore+=public/assets/**,build/**,vendor/plugins/**,vendor/linked_gems/**,vendor/gems/**,vendor/rails/**,vendor/ruby/**,vendor/cache/**,Libraries/**,coverage/**
let g:ctrlp_max_height=20
let g:ctrlp_user_command = ['.git/', 'cd %s && git ls-files . -co --exclude-standard']
let g:ctrlp_cache_dir = $HOME . '/.cache/ctrlp'
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v(\.git|\.yardoc|log|tmp)$',
  \ 'file': '\v\.(so|dat|DS_Store|png|gif|jpg|jpeg)$'
  \ }
let g:ctrlp_working_path_mode = 'ra'

" editorconfig
let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']

function! AlignSection(regex) range
    let extra = 1
    let sep = empty(a:regex) ? '=' : a:regex
    let maxpos = 0
    let section = getline(a:firstline, a:lastline)
    for line in section
        let pos = match(line, ' *'.sep)
        if maxpos < pos
            let maxpos = pos
        endif
    endfor
    call map(section, 'AlignLine(v:val, sep, maxpos, extra)')
    call setline(a:firstline, section)
endfunction

function! AlignLine(line, sep, maxpos, extra)
    let m = matchlist(a:line, '\(.\{-}\) \{-}\('.a:sep.'.*\)')
    if empty(m)
        return a:line
    endif
    let spaces = repeat(' ', a:maxpos - strlen(m[1]) + a:extra)
    return m[1] . spaces . m[2]
endfunction

" Align regexp
command! -nargs=? -range Align <line1>,<line2>call AlignSection('<args>')
vnoremap <silent> <Leader>a :Align<CR>

" git grep word under cursor
nmap <leader>r :Ggrep -wI <c-r>=expand("<cword>")<cr><cr>

" Fugitive
nmap <F9> :only<CR>:vsplit\|Git! diff -- %<CR>:set filetype=diff<CR>gg
nmap <F10> :only<CR>:vsplit\|Git! diff master -- %<CR>:set filetype=diff<CR>gg

" show diff in split when git committing
autocmd FileType gitcommit map <F9> :only<CR>:below vnew<CR>:read !git diff --cached<CR>:set syntax=diff buftype=nofile bufhidden=delete<CR>gg

" tagbar
nmap <F8> :TagbarToggle<CR>

" syntastic
let g:syntastic_php_checkers = ['php']
let g:syntastic_disabled_filetypes=['html']
let g:syntastic_html_checkers=['']
" XXX just for now till we have clean js
" let g:syntastic_javascript_checkers = ['']
" let g:syntastic_typescript_checkers = ['tsc', 'tslint']
let g:syntastic_typescript_checkers = ['tslint']
" let g:syntastic_typescript_tslint_args = "--config /Users/jmartin/repos/sg-frontend/tslint.json"
" let g:syntastic_javascript_checkers = ['eslint']
" let g:syntastic_javascript_eslint_args = "--config /Users/jeff/repos/tpt-frontend/.eslintrc"

" typescript
let g:typescript_compiler_options = '--outFile /dev/null --experimentalDecorators'
au FileType typescript nmap <silent> <leader>b :make<CR>
au Filetype typescript nmap <silent> <leader>B :call CompileTSOtherWindow()<CR>
au Filetype typescript nmap <silent> <leader>R <Plug>(TsuquyomiRenameSymbolC)
" disable quickfix for errors for now
let g:tsuquyomi_disable_quickfix = 1

" command! CompileTSOtherWindow
fun! CompileTSOtherWindow()
    let f = '/tmp/' . expand('%:t:r') . '.js'
    exe '!cd ' . expand('%:h') . ' && jspm bundle ' . expand('%:p') . ' ' . f
    exe 'only'
    exe 'vsplit|view ' . f
    exe 'normal G'
endfun

" ctags
set tags=./tags;

" Don't delete trailing whitespace for these filetypes
autocmd FileType snippets :let b:notrailing=1

" vim-go
" au FileType go nmap <leader>r <Plug>(go-run)
au FileType go nmap <leader>b <Plug>(go-build)
au FileType go nmap <leader>t <Plug>(go-test)
au FileType go nmap <leader>c <Plug>(go-coverage-toggle)
au FileType go nmap <leader>R <Plug>(go-referrers)
au FileType go nmap <leader>i <Plug>(go-imports)
au FileType go nmap <leader>T <Plug>(go-info)
au FileType go nmap <leader>m <Plug>(go-implements)
au FileType go nmap <leader>e <Plug>(go-iferr)

let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_interfaces = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1

let g:go_fmt_command = "goimports"
" let g:go_fmt_experimental = 1
let g:go_test_prepend_name = 1

let g:syntastic_go_checkers = ['golint', 'govet', 'errcheck']
let g:syntastic_go_checkers = ['govet', 'errcheck']
" let g:syntastic_go_checkers = ['gometalinter']
let g:syntastic_go_gometalinter_args = "--fast --disable='goconst' --disable='dupl' --cyclo-over=20"
let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go'] }
nmap <silent> <F7> :SyntasticCheck<CR>

" clang-format
au FileType typescript nmap <silent> <leader>f :ClangFormat<CR>
au FileType typescript vmap <silent> <leader>f :ClangFormat<CR>

" Ultisnips
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

" javascript libraries syntax
let g:used_javascript_libs = 'angularjs,angularuirouter,chai,underscore,jquery'

" abbrevs
abbrev tptf repos/tpt-frontend
abbrev gojm ~/go/src/github.com/jeffrom
abbrev gotpt ~/go/src/github.com/TeachersPayTeachers
abbrev tptapi repos/api/lib

" vimoutliner
au FileType votl,outliner setlocal shiftwidth=2 tabstop=2
au FileType outliner setlocal ft=votl

" fzf
set rtp+=/usr/local/opt/fzf
let $FZF_DEFAULT_OPTS = '--inline-info'
nnoremap <silent> <c-p> :Files <C-R>=ProjectRootGuess()<CR><CR>
command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>).' '.ProjectRootGuess().'| tr -d "\017"', 1, <bang>0)

" vrc
let g:vrc_curl_opts = {
            \ '-i': '',
            \ '--insecure': '',
            \}

autocmd BufRead,BufNewFile doc/tpt/curls.rest let b:vrc_header_content_type = 'application/graphql'

" rust
let g:racer_cmd = "/Users/jeff/.cargo/bin/racer"
let g:racer_experimental_completer = 1
au FileType rust nmap <silent> <leader>f :RustFmt<CR>
au FileType rust nmap <C-]> <Plug>(rust-def)
au FileType rust nmap K <Plug>(rust-doc)
let g:rustfmt_autosave = 1

" notational velocity
let g:nv_search_paths = ['~/notes']
nnoremap <silent> <leader>n :NV<CR>

au FileType typescript nmap <leader>f :Prettier<CR>

" set statusline+=%{FugitiveStatusline()}

" coc.nvim
" set updatetime=300

" Better display for messages
" set cmdheight=2

" don't give |ins-completion-menu| messages.
" set shortmess+=c

" always show signcolumns
" set signcolumn=yes

" au FileType typescript nmap <C-]> <Plug>(coc-definition)
" au FileType typescript nmap K :call <SID>show_documentation()<CR>
" au FileType typescript nmap <silent> <leader>R <Plug>(coc-references)
" au FileType typescript nmap <silent> gt <Plug>(coc-type-definition)
" au FileType typescript nmap <leader>rn <Plug>(coc-rename)
" au FileType typescript.tsx nmap <C-]> <Plug>(coc-definition)
" au FileType typescript.tsx nmap K :call <SID>show_documentation()<CR>
" au FileType typescript.tsx nmap <silent> <leader>R <Plug>(coc-references)
" au FileType typescript.tsx nmap <silent> gt <Plug>(coc-type-definition)
" au FileType typescript.tsx nmap <leader>rn <Plug>(coc-rename)

" function! s:show_documentation()
"   if (index(['vim','help'], &filetype) >= 0)
"     execute 'h '.expand('<cword>')
"   else
"     call CocAction('doHover')
"   endif
" endfunction


