let g:Tex_DefaultTargetFormat='pdf'
let g:Tex_MultipleCompileFormats='pdf,aux'
"let g:Tex_CompileRule_pdf='pdflatex -record -interaction=nonstopmode -file-line-error-style $*'
let g:Tex_CompileRule_pdf='latexmk %:r'
let g:Tex_SmartKeyDot=0
let g:Tex_Leader=',,'
let g:Tex_Leader2=',,'
let g:Tex_FoldedEnvironments='verbatim,comment,eq,gather,align,figure,table,thebibliography,keywords,abstract,titlepage,tabular,minipage,center,tikz'
let g:Tex_Env_document="\\documentclass<+[options]+>{<+class+>}\<CR>\<CR>\\begin{document}\<CR><++>\<CR>\\end{document}"
setlocal spell
setlocal iskeyword+=:
command! FreezeImap let b:Imap_FreezeImap=1
command! UnfreezeImap let b:Imap_FreezeImap=0
command! Wordcount w !detex |wc -w
nmap \le <Plug>Tex_LeftRight
