" Clean syntax file
" Language:     Clean functional programing language
" Author:       Tim Steenvoorden <t.steenvoorden@cs.ru.nl>
" Original By:  Jurriën Stutterheim <j.stutterheim@cs.ru.nl>
" License:      This file is placed in the public domain.
" Last Change:  7 Sep 2015

if exists("b:current_syntax")
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

syn keyword cleanConditional    if
syn keyword cleanStatement      let! let in with where case of
syn keyword cleanClass          class instance special
syn keyword cleanForeign        export foreign code
syn keyword cleanGeneric        generic derive
syn keyword cleanInfix          infixl infixr infix
" syn keyword cleanBuiltin        Int Real Char Bool String
" syn keyword cleanBuiltin        World ProcId Void Files File

syn match   cleanModule         "^\s*\(\(implementation\|definition\|system\)\s\+\)\?module\s\+" display
syn keyword cleanImport         from import as qualified
" syn region  cleanImport         start="^\s*\(from\|import\|\s\+\(as\|qualified\)\)" end="$" 

syn match   cleanChar           "'.'" display
syn region  cleanString         start=/"/ skip=/\\"/ end=/"/ oneline contains=@Spell
syn match   cleanInteger        "[+-~]\?\<\(\d\+\|0[0-7]\+\|0x[0-9A-Fa-f]\+\)\>" display
syn match   cleanReal           "[+-~]\?\<\d\+\.\d+\(E[+-~]\?\d+\)\?" display
syn keyword cleanBool           True False

syn match   cleanOperator       "[-~@#$%^?!+*<>\/|&=:.]\+" display
" syn match   cleanDelimiter      "=\(:\)\?\|:==\|\\\|->\|<-\(:\)\?" display
syn match   cleanDelimiter      "(\|)\|\[\(:\|#\|!\)\?\|\]\|{\(:\|#\|!\||\)\?\|\(:\||\)\?}\|,\|;" display
" syn match   cleanSpecial        "\<_\>" display

syn match   cleanFunction       "^\s*\((\(\a\w*`\?\|[-~@#$%^?!+*<>\/|&=:.]\+\))\|\a\w*`\?\)\(\_s\+infix[lr]\?\s\+\d\)\?\_s*::\_s*" display contains=TOP
syn match   cleanLambda         "\\\s*\(\a\w*`\?\s\+\)\+\(\.\|->\|=\)" display contains=TOP
syn match   cleanType           "^\s*::\s*\u\w*`\?`" display contains=TOP
syn match   cleanQualified      "'\w\+`\?'\." display
" syn match   cleanIdentifier     "\<\l\w*`\?\>" display
" syn match   cleanConstructor    "\<\u\w*`\?\>" display
" syn match   cleanType           ".\+\_s\+->\_s\+.\+" contained contains=TOP
" syn match   cleanAnnotation     "!\|\*\|\.\|\:\|<=" contained containedin=cleanType

syn keyword cleanTodo           TODO FIXME XXX BUG NB contained containedin=cleanComment
syn region  cleanComment        start="//"      end="$"   contains=@Spell oneline display
syn region  cleanComment        start="/\*"     end="\*/" contains=cleanComment,@Spell
if has('fold')
  syn region  cleanComment      start="^\s*/\*" end="\*/" contains=cleanComment,@Spell fold
endif

hi def link cleanConditional    Conditional
hi def link cleanStatement      Statement
hi def link cleanClass          Keyword
hi def link cleanForeign        Keyword
hi def link cleanGeneric        Keyword
hi def link cleanInfix          PreProc
" hi def link cleanBuiltin        Type

hi def link cleanModule         Include
hi def link cleanImport         Include

hi def link cleanChar           Character
hi def link cleanInteger        Number
hi def link cleanReal           Float
hi def link cleanString         String
hi def link cleanBool           Boolean

hi def link cleanOperator       Operator
hi def link cleanDelimiter      Delimiter
" hi def link cleanSpecial        Special

hi def link cleanFunction       Function
hi def link cleanLambda         Identifier
hi def link cleanType           Type
hi def link cleanQualified      Include
" hi def link cleanIdentifer      Identifier
" hi def link cleanConstructor    Type
" hi def link cleanAnnotation     Special

hi def link cleanTodo           Todo
hi def link cleanComment        Comment

syntax sync ccomment cleanComment
setlocal foldmethod=syntax

let b:current_syntax = 'clean'

let &cpo = s:cpo_save
unlet s:cpo_save

" vim: nowrap
