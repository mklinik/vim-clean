" Vim plugin for Clean development
" Language:     Clean functional programing language
" Maintainer:   Camil Staps <info@camilstaps.nl>
" Contributor:  Jurriën Stutterheim <j.stutterheim@cs.ru.nl>; Tim Steenvoorden <t.steenvoorden@cs.ru.nl>
" License:      This file is placed in the public domain.

if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

let s:cpo_save = &cpo
set cpo&vim

let b:undo_ftplugin = "setlocal com< cms< fo< sua<"

setlocal iskeyword+=`
setlocal comments=s1:/*,mb:*,ex:*/,://
setlocal commentstring=//\ %s

setlocal formatoptions-=tc formatoptions+=ro

setlocal suffixesadd=.icl,.dcl

compiler cpm

if !exists("g:clean_curlpath")
  let g:clean_curlpath = "curl"
endif

if !exists("g:clean_autoheader")
  let g:clean_autoheader = 1
endif

if !exists("g:clean_folding")
  let g:clean_folding = 1
endif

if g:clean_folding
  call cleanvim#fold#init()
endif

call cleanvim#cloogle#init()
call cleanvim#imports#init()
call cleanvim#modules#init()
call cleanvim#tags#init()

let &cpo = s:cpo_save
unlet s:cpo_save

" vim: expandtab shiftwidth=2 tabstop=2
