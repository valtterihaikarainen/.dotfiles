" CTERMFG COLOR REFERENCE (0-255)

" 0-15: ANSI Colors (also accept names)
" 0=black, 1=red, 2=green, 3=yellow, 4=blue, 5=magenta, 6=cyan, 7=white
" 8-15 = bright versions (brightred, brightblue, etc.)

" 16-231: 6×6×6 RGB Color Cube
" 16-21   = dark blues
" 22-27   = dark greens  
" 28-33   = dark cyans
" 52-57   = dark reds
" 88-93   = reds
" 124-129 = oranges/reds
" 130-135 = browns/oranges
" 160-165 = bright reds
" 166-171 = oranges
" 172-177 = yellows/golds
" 178-183 = light yellows
" 196-201 = bright reds/pinks
" 202-207 = bright oranges
" 208-213 = peach/salmon
" 214-219 = golds/yellows
" 220-225 = light yellows

" 232-255: Grayscale Ramp (24 shades)
" 232-235 = almost black (backgrounds)
" 236-239 = very dark gray (status bars, line numbers)
" 240-243 = dark gray (comments, secondary text)
" 244-247 = medium gray
" 248-251 = light gray
" 252-255 = very light gray (almost white)

colorscheme default

" Terminal emulator Background
highlight Comment ctermfg=102 

" Values & Constants
highlight Constant ctermfg=216 
highlight String ctermfg=151 
highlight Character ctermfg=151 
highlight Number ctermfg=216 
highlight Boolean ctermfg=216 
highlight Float ctermfg=216 

" Identifiers & Functions
highlight Identifier ctermfg=252 
highlight Function ctermfg=117 

" Keywords & Statements
highlight Statement ctermfg=183
highlight Conditional ctermfg=183
highlight Repeat ctermfg=183
highlight Label ctermfg=183
highlight Operator ctermfg=153
highlight Keyword ctermfg=183
highlight Exception ctermfg=183

" Preprocessor & Meta
highlight PreProc ctermfg=218 
highlight Include ctermfg=218 
highlight Define ctermfg=218 
highlight Macro ctermfg=229 
highlight PreCondit ctermfg=218 

" Types (Style Guide: Blue, not Yellow!)
highlight Type ctermfg=117 
highlight StorageClass ctermfg=117 
highlight Structure ctermfg=117 
highlight Typedef ctermfg=117 

" Special & Attributes
highlight Special ctermfg=218 
highlight SpecialChar ctermfg=218 
highlight Tag ctermfg=183 
highlight Delimiter ctermfg=102 
highlight SpecialComment ctermfg=102 
highlight Debug ctermfg=211 

" Builtins (Style Guide: Red)
highlight Builtin ctermfg=211 

" UI Elements
highlight LineNr ctermfg=102 
highlight CursorLineNr ctermfg=183 
highlight Visual ctermbg=237 guibg=#45475a
highlight Search ctermbg=216 ctermfg=234 guibg=#fab387 
highlight IncSearch ctermbg=211 ctermfg=234 guibg=#f38ba8 

" Errors & Warnings
highlight Error ctermfg=211 ctermbg=NONE 
highlight Todo ctermfg=229 ctermbg=NONE 
highlight WarningMsg ctermfg=216 

" LSP 
highlight LspReferenceText ctermbg=236 
highlight LspReferenceRead ctermbg=236 
highlight LspReferenceWrite ctermbg=236 
highlight LspErrorHighlight cterm=underline ctermfg=Red 
highlight LspWarningHighlight cterm=underline ctermfg=Yellow 
highlight LspInformationHighlight cterm=underline ctermfg=Blue 
highlight LspHintHighlight cterm=underline ctermfg=Green 

