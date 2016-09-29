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

silent! unmap <Plug>
