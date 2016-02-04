syn match	schemeOther	"[+-][a-z!$%&*/:<=>?^_~+@#%-][-a-z!$%&*/:<=>?^_~0-9+.@#%]*"
syn region schemeMultilineComment start=/#|/ end=/|#/ contains=@Spell,schemeMultilineComment
syn keyword schemeExtSyntax ->environment ->namestring
syn match schemeExtSyntax "#![-a-z!$%&*/:<=>?^_~0-9+.@#%]\+"
syn match schemeAtomMark "'"
syn match schemeAtom "'[^ \t()\[\]{}]\+" contains=schemeAtomMark
syn cluster schemeListCluster contains=schemeSyntax,schemeFunc,schemeString,schemeCharacter,schemeNumber,schemeBoolean,schemeConstant,schemeComment,schemeMultilineComment,schemeQuoted,schemeUnquote,schemeStrucRestricted,schemeOther,schemeError,schemeExtSyntax,schemeExtFunc,schemeAtom,schemeDelimiter

hi def link schemeAtomMark Delimiter
hi def link schemeAtom Identifier
