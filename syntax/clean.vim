" Clean syntax file
" Language:     Concurrent Clean
" Author:       Camil Staps <info@camilstaps.nl>
" Original By:  Jurriën Stutterheim <j.stutterheim@cs.ru.nl>; Tim Steenvoorden <t.steenvoorden@cs.ru.nl>
" License:      This file is placed in the public domain.

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
if g:clean_highlight_o
	syn keyword cleanO          o
endif

syn match   cleanForeign        "\<foreign export\( \(c\|std\)call\>\)\?"
syn region  cleanABC            matchgroup=cleanForeign start="\<code\(\s\|\n\)*\(\<inline\(\s\|\n\)*\)\?{" end="}" contains=@ABC transparent

syn match   cleanModule         "^\s*\(\(implementation\|definition\|system\)\s\+\)\?module\s\+" display
syn match   cleanImportMod      "\(\<from\>.*\)\?\<import\>\s*\(qualified\)\?.*$" display contains=cleanImportKeyword,cleanClass,cleanGeneric,cleanDelimiter,cleanOperator,cleanO
syn match   cleanImportKeyword  "\<\(as\|from\|import\|qualified\)\>" contained containedin=cleanImportMod

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
syn region  cleanGenericArg     matchgroup=cleanGenericDelim start="{|" end="|}" oneline contains=cleanGenericDelim,cleanGenericArg keepend
syn match   cleanGenericOf      "\<of\>" display contained containedin=cleanGenericArg

syn match   cleanFunction       "^\s*\((\(\a\w*`\?\|[-~@#$%^?!+*<>\/|&=:.]\+\))\|\a\%\(\w\|`\)*\)\(\_s\+infix[lr]\?\s\+\d\)\?\_s*::\_s*" display contains=TOP
syn match   cleanLambda         "\\\s*\([a-zA-Z_]\w*`\?\s*\)\+\(\.\|->\|=\)" display contains=TOP
syn match   cleanTypeDef        "^\s*::\s*\*\?\u\w*`*\s*\($\|\([a-z0-9_` \t]*\(=\|:==\|(:==\)\)\)\@=" display contains=TOP
syn match   cleanQualified      "'\w\+`\?'\.[^.]\@=" display

syn keyword cleanTodo           TODO FIXME XXX BUG NB contained containedin=cleanComment
syn region  cleanComment        start="//"      end="$"   contains=@Spell oneline display
syn region  cleanComment        start="/\*"     end="\*/" contains=cleanComment,@Spell
syn region  cleanComment        start="^\s*/\*" end="\*/" contains=cleanComment,@Spell fold keepend extend

hi def link cleanConditional    Conditional
hi def link cleanStatement      Statement
hi def link cleanClass          Keyword
hi def link cleanForeign        Keyword
hi def link cleanGeneric        Keyword
hi def link cleanInfix          PreProc
hi def link cleanO              Operator

hi def link cleanModule         Include
hi def link cleanImportKeyword  Include

hi def link cleanChar           Character
hi def link cleanCharList       Character
hi def link cleanInteger        Number
hi def link cleanReal           Float
hi def link cleanString         String
hi def link cleanSpecialChar    String
hi def link cleanBool           Boolean
hi def link cleanGenericArg     Type
hi def link cleanGenericOf      Keyword
hi def link cleanGenericDelim   Delimiter

hi def link cleanOperator       Operator
hi def link cleanDelimiter      Delimiter

hi def link cleanFunction       Function
hi def link cleanLambda         Identifier
hi def link cleanTypeDef        Type
hi def link cleanQualified      Include

hi def link cleanTodo           Todo
hi def link cleanComment        Comment

syntax sync ccomment cleanComment

let b:current_syntax = 'clean'

let &cpo = s:cpo_save
unlet s:cpo_save
