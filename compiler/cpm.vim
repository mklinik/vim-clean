" Vim compiler file
" Compiler:     Clean Project Manager
" Maintainer:   Tim Steenvoorden <tim.steenvoorden@gmail.com>
" Last Change:  7 Sep 2014

" Initialize Compiler File: {{{1
" =========================

if exists('b:current_compiler')
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

" Setups: {{{1
" =======

let b:clean_module = expand('%:t:r', 1)
let b:clean_project_file = b:clean_module . '.prj'

if filereadable(b:clean_project_file)
	let &l:makeprg = 'cpm project ' . b:clean_project_file . ' build'
else
	let &l:makeprg = 'cpm make'
endif

setlocal isfname-=,
let &l:errorformat  = '%E%trror [%f\,%l]: %m' " General error (without location info)
let &l:errorformat .= ',%E%trror [%f\,%l\,]: %m' " General error (without location info)
let &l:errorformat .= ',%E%trror [%f\,%l\,%s]: %m' " General error
let &l:errorformat .= ',%E%type error [%f\,%l\,%s]:%m' " Type error
let &l:errorformat .= ',%E%tverloading error [%f\,%l\,%s]:%m' " Overloading error
let &l:errorformat .= ',%E%tniqueness error [%f\,%l\,%s]:%m' " Uniqueness error
let &l:errorformat .= ',%E%tarse error [%f\,%l;%c\,%s]: %m' " Parse error
let &l:errorformat .= ',%+C %m' " Extra info
let &l:errorformat .= ',%-G%s' " Ignore rest

" Finalize Compiler File: {{{1
" =======================

let b:current_compiler = 'cpm'

let &cpo = s:cpo_save
unlet s:cpo_save

" vim: ts=2 sw=2 fdm=marker
