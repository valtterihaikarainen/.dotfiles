" Set leader key
let mapleader = " "

nnoremap <leader>e :Ex<CR>
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>rc :edit $MYVIMRC<CR>
nnoremap <leader>o :so $MYVIMRC<CR>
nnoremap <leader>n :bn<CR>

" Remove highlights
nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>


