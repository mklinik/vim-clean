" Vim compiler file
" Compiler:   CLPM
" Maintainer: Camil Staps <info@camilstaps.nl>

if exists('b:current_compiler')
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

let &l:makeprg = 'clpm make'

setlocal isfname-=,

let &l:errorformat  = '%E%trror [%f\,%l]: %m'
let &l:errorformat .= ',%E%trror [%f\,%l\,]: %m'
let &l:errorformat .= ',%E%trror [%f\,%l\,%s]: %m'
let &l:errorformat .= ',%EType %trror [%f\,%l\,%s]:%m'
let &l:errorformat .= ',%EOverloading %trror [%f\,%l\,%s]:%m'
let &l:errorformat .= ',%EUniqueness %trror [%f\,%l\,%s]:%m'
let &l:errorformat .= ',%EParse %trror [%f\,%l;%c\,%s]: %m'

" These first two warnings include 'no inline code' and 'not all derived
" strictness exported', which are generally not very helpful
"let &l:errorformat .= ',%W%tarning [%f\,]: %m'
"let &l:errorformat .= ',%W%tarning [%f\,%l\,%s]: %m'
let &l:errorformat .= ',%WParse %tarning [%f\,%l\;%c]: %m'

let &l:errorformat .= ',%+C %m' " Extra info
let &l:errorformat .= ',%-G%s' " Ignore rest

let b:current_compiler = 'clpm'

let &cpo = s:cpo_save
unlet s:cpo_save

" vim: ts=2 sw=2 fdm=marker
