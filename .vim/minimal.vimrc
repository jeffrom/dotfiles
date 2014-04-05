syntax on
set hidden
colorscheme inkpot
set incsearch

map <F9> :only<CR>:below vnew<CR>:read !svn diff<CR>:set syntax=diff buftype=nofile bufhidden=delete<CR>gg
nnoremap ; :
map <silent> <leader><leader> :set hlsearch! hlsearch?<CR>
