 " " Python - Pyright (type checking, intellisense)
 " if executable('pyright-langserver')
 "     au User lsp_setup call lsp#register_server({
 "         \ 'name': 'pyright',
 "         \ 'cmd': {server_info->['pyright-langserver', '--stdio']},
 "         \ 'allowlist': ['python'],
 "         \ 'workspace_config': {
 "         \   'python': {
 "         \     'analysis': {
 "         \       'typeCheckingMode': 'basic',
 "         \       'autoSearchPaths': v:false,
 "         \       'useLibraryCodeForTypes': v:false,
 "         \     }
 "         \   }
 "         \ }
 "         \ })
 " endif
 " 
