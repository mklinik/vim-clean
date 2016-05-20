" Vim plugin for Clean development
" Language:     Clean functional programing language
" Maintainer:   Jurriën Stutterheim <j.stutterheim@cs.ru.nl>
" Contributor:  Tim Steenvoorden <t.steenvoorden@cs.ru.nl>
" License:      This file is placed in the public domain.
" Last Change:  3 Sep 2015

if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

let s:cpo_save = &cpo
set cpo&vim

let b:undo_ftplugin = "setlocal com< cms< fo< sua<"

setlocal comments=s1:/*,mb:*,ex:*/,://
setlocal commentstring=//\ %s

setlocal formatoptions-=tc formatoptions+=ro

setlocal suffixesadd=.icl,.dcl

compiler cpm

if !exists("*s:CleanSwitchModule")
  function s:CleanSwitchModule()
    let file_name = expand("%:r")
    if expand("%:e") == "icl"
      let new_file_name = file_name . "." . "dcl"
    else
      let new_file_name = file_name . "." . "icl"
    endif
    exec "edit " . new_file_name
  endfunction
endif

map <buffer> <LocalLeader>m :call <SID>CleanSwitchModule()<CR>

let b:all_tag_files = split(globpath('./Clean\ System\ Files/ctags', '*_tags'), '\n')
for b:tag_file_name in b:all_tag_files
  exec "set tags+=" . substitute(b:tag_file_name, "Clean System Files", "Clean\\\\\\\\\\\\\ System\\\\\\\\\\\\ Files", "") . ";"
endfor

let &cpo = s:cpo_save
unlet s:cpo_save

