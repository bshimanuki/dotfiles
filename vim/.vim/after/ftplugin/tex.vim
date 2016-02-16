" Undo some latex-suite macros
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

silent! unmap <Plug>
