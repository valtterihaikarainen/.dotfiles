" Plugin Manager
let s:plugin_dir = expand('~/.config/vim/plugins')

function! s:ensure(repo)
  let name = split(a:repo, '/')[-1]
 let path = s:plugin_dir . '/' . name
  
  if !isdirectory(path)
    if !isdirectory(s:plugin_dir)
      call mkdir(s:plugin_dir, 'p')
    endif
    execute '!git clone --depth=1 https://github.com/' . a:repo . ' ' . shellescape(path)
  endif
  execute 'set runtimepath+=' . fnameescape(path)
endfunction

" Plugins
call s:ensure('prabirshrestha/vim-lsp')
