" Undo some latex-suite macros
if exists('*IMAP')
  call IMAP('()', '()', 'tex')
  call IMAP('{}', '{}', 'tex')
  call IMAP('[]', '[]', 'tex')
  call IMAP('::', '::', 'tex')
  call IMAP('{{', '{{', 'tex')
  call IMAP('((', '((', 'tex')
  call IMAP('[[', '[[', 'tex')
  call IMAP('$$', '$$', 'tex')
  call IMAP('~~', '~~', 'tex')
  call IMAP('SPA', 'SPA', 'tex')
endif

" latex-suite settings
let b:Tex_DefaultTargetFormat='pdf'
let b:Tex_MultipleCompileFormats='pdf,aux'
"let b:Tex_CompileRule_pdf='pdflatex -record -interaction=nonstopmode -file-line-error-style $*'
let b:Tex_CompileRule_pdf='latexmk %:r'
let b:Tex_SmartKeyDot=0
let b:Tex_Leader=',,'
let b:Tex_Leader2=',,'
let b:Tex_FoldedEnvironments='verbatim,comment,eq,gather,align,figure,table,thebibliography,keywords,abstract,titlepage,tabular,minipage,center,tikz'
let b:Tex_Env_document="\\documentclass<+[options]+>{<+class+>}\<CR>\<CR>\\begin{document}\<CR><++>\<CR>\\end{document}"
command! FreezeImap let b:Imap_FreezeImap=1
command! UnfreezeImap let b:Imap_FreezeImap=0
nmap \le <Plug>Tex_LeftRight

silent! unmap <Plug>
