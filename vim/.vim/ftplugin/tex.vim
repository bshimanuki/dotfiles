let g:Tex_DefaultTargetFormat='pdf'
let g:Tex_MultipleCompileFormats='pdf,aux'
let g:Tex_CompileRule_pdf='pdflatex -record -interaction=nonstopmode -file-line-error-style $*'
let g:Tex_SmartKeyDot=0
let g:Tex_Leader=',,'
let g:Tex_Leader2=',,'
let g:Tex_FoldedEnvironments='verbatim,comment,eq,gather,align,figure,table,thebibliography,keywords,abstract,titlepage,tabular,minipage,center'
setlocal spell
set iskeyword+=:
command! Wordcount w !detex |wc -w
