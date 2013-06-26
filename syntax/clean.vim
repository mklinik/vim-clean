" Clean syntax file
" Language: Clean
" Maintainer: Jurriën Stutterheim
" Latest Revision: 2013 June 25

if exists("b:clean_syntax")
  finish
endif

syn keyword cleanTodo TODO FIXME XXX contained

syn region cleanComment start="//.*" end="$" contains=cleanTodo
syn region cleanComment start="/\*" end="\*/" contains=cleanTodo fold

syn keyword cleanConditional if case
syn keyword cleanLabel let! let with where in of
syn match cleanLabel "\s\+#\(!\)\?\s\+" display
syn keyword cleanKeyword infixl infixr infix
syn keyword cleanTypeClass class instance export
syn keyword cleanBasicType Int Real Char Bool String
syn keyword cleanSpecialType World ProcId Void Files File

syn match cleanCharDenot "'.'" display
syn match cleanCharsDenot "'[^'\\]*\(\\.[^'\\]\)*'" contained display
syn match cleanIntegerDenot "[+-~]\=\<\(\d\+\|0[0-7]\+\|0x[0-9A-Fa-f]\+\)\>" display
syn match cleanRealDenot "[+-~]\=\<\d\+\.\d+\(E[+-~]\=\d+\)\=" display
syn region cleanStringDenot start=/"/ skip=/\\"/ end=/"/ fold
syn keyword cleanBoolDenot True False

syn match cleanModuleSystem "^\(implementation\|definition\|system\)\?\s\+module" display

syn region cleanIncludeRegion start="^\s*\(from\|import\|\s\+\(as\|qualified\)\)" end="$" contains=cleanIncludeKeyword,cleanDelimiters keepend
syn keyword cleanIncludeKeyword contained from import as qualified

syn match cleanQualified "'[A-Za-z0-9_\.]\+'\."

syn match cleanDelimiters "(\|)\|\[\|\]\|{\(:\)\?\|\(:\)\?}\|,\||\|&\|;"

syn match cleanTypeDef "^\s*::"
syn match cleanFuncTypeDef "^\s*\((\?\a\+\w*)\?\|(\?[-~@#$%^?!+*<>\/|&=:]\+)\?\)\(\s\+infix[lr]\?\s\+\d\)\?\s\+::.*" contains=cleanSpecialType,cleanBasicType,cleanDelimiters,cleanTypeAnnot,cleanFuncDef
syn match cleanFuncDef "^\s*\((\?\a\+\w*)\?\|(\?[-~@#$%^?!+*<>\/|&=:]\+)\?\)\(\s\+infix[lr]\?\s\+\d\)\?\s\+::" contained
syn match cleanTypeAnnot "\(!\|\*\|\.\|\:\|<=\)" contained

syn match cleanOperators "=\(:\)\?\|\s\+o\s\+\|\\\|->\|<-"

command -nargs=+ HiLink hi def link <args>

HiLink cleanTodo            Todo

HiLink cleanComment         Comment
HiLink cleanConditional     Conditional

HiLink cleanLabel           Label
HiLink cleanKeyword         Keyword
HiLink cleanTypeClass       Keyword
HiLink cleanIncludeKeyword  Include
HiLink cleanBasicType       Type
HiLink cleanSpecialType     Type

HiLink cleanModuleSystem    Keyword
HiLink cleanIncludeKeyword  Include

HiLink cleanQualified       Identifier

HiLink cleanCharDenot       Character
HiLink cleanCharsDenot      String
HiLink cleanStringDenot     String
HiLink cleanIntegerDenot    Number
HiLink cleanRealDenot       Float
HiLink cleanBoolDenot       Boolean

HiLink cleanDelimiters      Delimiter

HiLink cleanTypeDef         Typedef
HiLink cleanFuncTypeDef     Type
HiLink cleanFuncDef         Function
HiLink cleanTypeAnnot       Special

HiLink cleanOperators       Operator

delcommand HiLink

let b:current_syntax = "clean"
