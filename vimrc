"call pathogen#incubate()
call pathogen#infect('bundle/{}')

syntax on
filetype plugin indent on
set tabstop=4
set shiftwidth=4
set expandtab
set nosmartindent  " plugin indent on seems to do a better job
set hidden
colorscheme inkpot
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

" stay three lines from the bottom
set scrolloff=3

fun! SetJSOptions()
    map <buffer> <silent><leader>d :TernDef<CR>
    map <buffer> <silent><leader>R :TernRefs<CR>
    map <buffer> <silent>K :TernType<CR>
    map <buffer> <C-]> :TernDef<CR>
    let javascript_ignore_javaScriptdoc = 1
    "let g:javascript_conceal = 1
endfun

fun! TextSetup()
    setlocal spell spelllang=en_us
    setlocal colorcolumn=79
    setlocal tw=78
    setlocal list
endfun

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

fun! TextSetup()
    setlocal spell spelllang=en_us
    setlocal colorcolumn=79
    setlocal tw=78
    setlocal list
endfun

fun! StripTrailingWhitespace()
    if exists("b:notrailing")
        return
    endif
    %s/\s\+$//e
endfun

" grep for word under cursor
fun! CursorGrep()
    " /home/jeff/code
    let s:cwd = getcwd()
    let s:word = expand('<cword>')
    let s:curr_file = bufname('%')
    let s:path_parts = split(s:curr_file, '/')

    if len(s:path_parts) > 1
        let s:final_path = s:path_parts[0]
    elseif matchstr(s:curr_file[0], '[~\\/]')
        let s:final_path = join(s:path_parts[:len(s:path_parts) - 2], '/')
    else
        let s:final_path = s:cwd . '/'
    endif

    exe "grep -r " . s:word . ' ' . s:final_path . ' --include=*.' . expand("%:e")
endfun

function! GetVisualSelection()
    let [lnum1, col1] = getpos("'<")[1:2]
    let [lnum2, col2] = getpos("'>")[1:2]
    let lines = getline(lnum1, lnum2)
    let lines[-1] = lines[-1][: col2 - 2]
    let lines[0] = lines[0][col1 - 1:]
    return join(lines, "\n")
endfunction

" print pretty json into the buffer
fun! ReadJson() range
    let selection = getline(a:firstline, a:lastline)
    for line in selection
        " strip
        let line = substitute(line, '^\s*\(.\{-}\)\s*$', '\1', '')
        if !len(line)
            continue
        endif

        let firstch = line[0]
        let lastch = line[strlen(line) - 1]
        if (firstch == '{' && lastch == '}') || (firstch == '[' && lastch == ']')
            let parsed = system("echo '" . line . "' | python -m json.tool 2> /dev/null")
            if !len(parsed)
                continue
            endif
            delete
            call append('.', '')
            call append('.', split(parsed, '\n'))
            delete
        endif
    endfor
endfun

" clean up mustaches
fun! CleanMustaches()
    %s/{{\([a-z_]*\)}}/{{ \1 }}/ge
    %s/{{#\([a-z_]*\)}}/{{# \1 }}/ge
    %s/{{\/\([a-z_]*\)}}/{{\/ \1 }}/ge
    %s/{{\^\([a-z_]*\)}}/{{^ \1 }}/ge
    %s/{{>\([a-z_]*\)}}/{{> \1 }}/ge
    %s/{{js>\([a-z_]*\)}}/{{js> \1 }}/ge
endfun

if filereadable($HOME . '/.vim/plugin/echofunc.vim')
    " some stuff to smartly show echofunc
    fun! EchoFuncStatusLineOn()
        " this creates basically a default statusline
        " it also adds function declarations
        set statusline=
        set statusline+=%f
        set statusline+=\ %m
        set statusline+=\ %r
        set statusline+=\ %{EchoFuncGetStatusLine()}
        set statusline+=%=
        set statusline+=%l,%c
        set statusline+=\ \ \ \ \ \ \ \ \ %P
        let g:EchoFuncShowOnStatus=1
    endfun

    fun! EchoFuncStatusLineOff()
        set statusline=
        let g:EchoFuncShowOnStatus=0
    endfun

    fun! NumWindows()
        return winnr('$')
    endfun

    " use the status line for function declarations if we have one window
    " open, otherwise use the message line
    fun! MaybeShowEchoFunc()
        if &buftype == "quickfix"
            call EchoFuncStatusLineOff()
            return
        endif

        if NumWindows() == 1
            call EchoFuncStatusLineOn()
        else
            call EchoFuncStatusLineOff()
        endif
    endfun

    let g:EchoFuncKeyNext="<c-g>"
    " no can haz js :(
    let g:EchoFuncLangsUsed=["python", "php", "java", "c", "perl"]
    set laststatus=2
    call EchoFuncStatusLineOn()

    autocmd InsertEnter * call MaybeShowEchoFunc()
    map <silent> <leader>f :call EchoFuncClear()<cr>:call MaybeShowEchoFunc()<cr>
endif

fun! SetupPython()
    " pyflakes on this file
    map <silent><leader>p :cex system('pyflakes ' . expand('%'))<CR>:cw<CR>
    "map <silent><leader>b Oimport pdb; pdb.set_trace()<ESC>
    map <silent><leader>b Oimport ipdb; ipdb.set_trace()<ESC>
    map <silent><leader>e :!python %<CR>

    fun! PrintQuerySelection() range
        " this works with large selections
        let filename = '/tmp/__vim.tmpbuf.txt'
        call writefile(getline(a:firstline, a:lastline), l:filename)
        exe '!sqljunk.py < ' . filename
        call delete(l:filename)
    endfun
    command! -range PrintQuery <line1>,<line2>call PrintQuerySelection()

    " make an easy to copy version of a multiline python query
    map <leader>q v%:PrintQuery<CR>
    vmap <leader>q :PrintQuery<CR>
endfun

fun! MakeStuff()
    let g:oldpath = getcwd()
    exe "cd " . expand('%:h')
    setl makeprg=vim_make.sh\ %
    "let &errorformat='some format'.','
    "let &errorformat.='%-G%.%#'
    silent make
    redraw!
    exe "cd " . g:oldpath
    cwindow
endfun

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

" fix color scheme for outliner
autocmd FileType vo_base :colorscheme vo_dark

autocmd BufRead,BufNewFile *.go set filetype=go
autocmd FileType go compiler go
autocmd FileType go autocmd BufWritePre <buffer> Fmt
let g:golang_goroot = "/usr/lib/go"

autocmd FileType html,javascript,mustache setlocal shiftwidth=2 tabstop=2
autocmd FileType javascript call SetJSOptions()

autocmd BufRead,BufNewFile ~/doc/*.txt,~/doc/*/*.txt call TextSetup()
"autocmd BufRead,BufNewFile *.sls set filetype=yaml

" Delete trailing whitespace on save
autocmd BufWritePre * :call StripTrailingWhitespace()

" In order to retab tabs back to 4 whitespaces:
" 1,$ retab! 8  - convert tab to 8 whitespaces
" u             - undo will then make it back to tab + 4 whitespaces
" 1,$ retab! 4  - convert tab to 4 whitespaces

" Get an svn diff in the other window
map <F9> :only<CR>:below vnew<CR>:read !svn diff<CR>:set syntax=diff buftype=nofile bufhidden=delete<CR>gg

autocmd FileType gitcommit map <F9> :only<CR>:below vnew<CR>:read !git diff --cached<CR>:set syntax=diff buftype=nofile bufhidden=delete<CR>gg

map <leader>h :vs %:p:s,.h$,.X123X,:s,.c$,.h,:s,.X123X$,.c,<CR>
map <leader>H :e %:p:s,.h$,.X123X,:s,.c$,.h,:s,.X123X$,.c,<CR>

" search recursively from the current directory for tags files
" first check tags, then shared libraries tags, then stdlib
set tags=./tags;$HOME,./stdlib.tags;$HOME,./shared.tags;$HOME

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

autocmd BufRead ~/doc/*.txt,~/doc/*/*.txt call TextSetup()

" Toggle highlight when <leader><leader> is pressed
map <silent> <leader><leader> :set hlsearch! hlsearch?<CR>

" Underline the current line with dashes in normal mode
nnoremap <leader>_ yyp<c-v>$r-

" dont show statusline in svn editor
autocmd FileType svn set laststatus=1

" Align regexp
command! -nargs=? -range Align <line1>,<line2>call AlignSection('<args>')
vnoremap <silent> <Leader>a :Align<CR>

map <silent> <leader>r :call CursorGrep()<CR>

" spell check
map <silent> <leader>s :setlocal spell! spell? spelllang=en_us<CR>

" svn blame
vmap <leader>b :<C-U>!svn blame <C-R>=expand("%:p") <CR> \| sed -n <C-R>=line("'<") <CR>,<C-R>=line("'>") <CR>p <CR>

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

" UltiSnips settings
if has('python')
    let g:UltiSnipsExpandTrigger="<tab>"
    let g:UltiSnipsJumpForwardTrigger="<tab>"
    let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
endif

autocmd FileType python call SetupPython()

command! Make call MakeStuff()
map <leader>m :Make<CR>

map <silent> <leader>M :call CleanMustaches()<CR>
map <silent> <leader>j :call ReadJson()<CR>

