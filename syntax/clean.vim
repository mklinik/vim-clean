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

syn include @ABC <sfile>:p:h/abc.vim

syn keyword cleanConditional    if otherwise
syn keyword cleanStatement      let! let in with where case of dynamic
syn keyword cleanClass          class instance special
syn keyword cleanGeneric        generic derive
syn keyword cleanInfix          infixl infixr infix

syn match   cleanForeign        "\<foreign export\( \(c\|std\)call\>\)\?"
syn region  cleanABC            matchgroup=cleanForeign start="\<code\(\s\|\n\)*\(\<inline\(\s\|\n\)*\)\?{" end="}" contains=@ABC transparent

syn match   cleanModule         "^\s*\(\(implementation\|definition\|system\)\s\+\)\?module\s\+" display
syn keyword cleanImport         from import as qualified

syn match   cleanSpecialChar    contained "\\\([0-9]\+\|o[0-7]\+\|x[0-9a-fA-F]\+\|[\"\\'&abfnrtv]\)"
syn match   cleanChar           "'\\\([0-9]\+\|o[0-7]\+\|x[0-9a-fA-F]\+\|[\"\\'&abfnrtv]\)'" display
syn match   cleanChar           "'.'" display
syn region  cleanString         start=+"+ skip=+\\\\\|\\"+ end=+"+ oneline contains=cleanSpecialChar
syn region  cleanCharList       start=+'+ skip=+\\\\\|\\'+ end=+'+ oneline contains=cleanSpecialChar
syn match   cleanInteger        "[+-~]\?\<\(\d\+\|0[0-7]\+\|0x[0-9A-Fa-f]\+\)\>" display
syn match   cleanReal           "[+-~]\?\<\d\+\.\d+\(E[+-~]\?\d+\)\?" display
syn keyword cleanBool           True False

syn match   cleanOperator       "[-~@#$%^?!+*<>\/|&=:.]\+" display
syn match   cleanDelimiter      "(\|)\|\[\(:\|#\|!\)\?\|\]\|{\(:\|#\|!\||\)\?\|\(:\||\)\?}\|,\|;" display

syn match   cleanFunction       "^\s*\((\(\a\w*`\?\|[-~@#$%^?!+*<>\/|&=:.]\+\))\|\a\%\(\w\|`\)*\)\(\_s\+infix[lr]\?\s\+\d\)\?\_s*::\_s*" display contains=TOP
syn match   cleanLambda         "\\\s*\([a-zA-Z_]\w*`\?\s*\)\+\(\.\|->\|=\)" display contains=TOP
syn match   cleanTypeDef        "^\s*::\s*\u\w*`\?`" display contains=TOP
syn match   cleanQualified      "'\w\+`\?'\." display

syn region  cleanRecordDef      start="{"       end="}"   transparent fold contains=cleanRecordField,cleanRecordDef
syn match   cleanRecordField    "[{,&|]\@<=\_s*\a[a-zA-Z0-9_`]*\_s*\(::\|[=,}]\)\@=" display contained

syn keyword cleanTodo           TODO FIXME XXX BUG NB contained containedin=cleanComment
syn region  cleanComment        start="//"      end="$"   contains=@Spell oneline display
syn region  cleanComment        start="/\*"     end="\*/" contains=cleanComment,@Spell
syn region  cleanComment        start="^\s*/\*" end="\*/" contains=cleanComment,@Spell fold keepend extend

syn match   cleanAllCaps        "\_s\@<=\u[A-Z0-9_]\+\>" display

hi def link cleanConditional    Conditional
hi def link cleanStatement      Statement
hi def link cleanClass          Keyword
hi def link cleanForeign        Keyword
hi def link cleanGeneric        Keyword
hi def link cleanInfix          PreProc

hi def link cleanModule         Include
hi def link cleanImport         Include

hi def link cleanChar           Character
hi def link cleanCharList       Character
hi def link cleanInteger        Number
hi def link cleanReal           Float
hi def link cleanString         String
hi def link cleanSpecialChar    String
hi def link cleanBool           Boolean

hi def link cleanOperator       Operator
hi def link cleanDelimiter      Delimiter

hi def link cleanFunction       Function
hi def link cleanLambda         Identifier
hi def link cleanTypeDef        Type
hi def link cleanQualified      Include

hi def link cleanRecordField    Identifier

hi def link cleanTodo           Todo
hi def link cleanComment        Comment

hi def link cleanAllCaps        Constant

syntax sync ccomment cleanComment

let b:current_syntax = 'clean'

let &cpo = s:cpo_save
unlet s:cpo_save
