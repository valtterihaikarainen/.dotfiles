
function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=no
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> K <plug>(lsp-hover)
endfunction

augroup lsp_settings
    autocmd!
    autocmd User LspBufferEnabled call s:on_lsp_buffer_enabled()
augroup END

"###############################################################
" Yank to system clipboard with Osc52
"###############################################################

function! Osc52Yank()
    let buffer=system('base64 -w0', @")
    let buffer='\e]52;c;'.buffer.'\x07'
    silent exe "!echo -ne ".shellescape(buffer)." > /dev/tty"
endfunction

autocmd TextYankPost * call Osc52Yank()

let &t_SI = "\e[5 q"  " Insert mode: vertical bar
let &t_EI = "\e[2 q"  " Normal mode: block
let &t_SR = "\e[4 q"  " Replace mode: underline


