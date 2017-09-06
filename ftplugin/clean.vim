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

if !exists("*s:CleanSwitchModule")
  function s:CleanSwitchModule(cmd)
    let basename = expand("%:r")
    let filename = basename . (expand('%:e') == 'icl' ? '.dcl' : '.icl')
    for tabNo in range(1, tabpagenr("$"))
      for bufInTab in tabpagebuflist(tabNo)
         if bufname(bufInTab) == filename
           exec 'tabn ' . tabNo
           return
         endif
      endfor
    endfor

    "Not open in a tab, thus we spawn a new one
    exec a:cmd . ' ' . filename

    if g:clean_autoheader && !filereadable(filename)
      let modname = substitute(basename, '/', '.', 'g')
      let header = expand('%:e') == 'icl' ? 'definition' : 'implementation'
      exec 'normal i' . header . ' module ' . modname . "\<CR>\<CR>\<Esc>"
    endif
  endfunction
endif

command! -nargs=1 CleanSwitchModule :call <SID>CleanSwitchModule(<args>)
map <buffer> <LocalLeader>mm :call <SID>CleanSwitchModule('edit')<CR>
map <buffer> <LocalLeader>mt :call <SID>CleanSwitchModule('tabedit')<CR>
map <buffer> <LocalLeader>ms :call <SID>CleanSwitchModule('split')<CR>
map <buffer> <LocalLeader>mv :call <SID>CleanSwitchModule('vsplit')<CR>

if !exists("*s:CloogleWindow")
  function! s:CloogleWindow()
    if !exists('g:clean#cloogle#window')
      echo 'First search using :Cloogle, then you may open a window'
      return
    endif

    if !exists('s:cloogle_window_file')
      let s:cloogle_window_file = tempname()
    endif

    if bufloaded(s:cloogle_window_file)
      execute 'silent bdelete' s:cloogle_window_file
    endif
    call writefile(g:clean#cloogle#window, s:cloogle_window_file)
    execute 'silent pedit ' . s:cloogle_window_file

    wincmd P |
    wincmd J
    resize +10

    set bufhidden=wipe
    setlocal buftype=nofile noswapfile readonly nomodifiable filetype=clean
  endfunction
endif

if !exists("*s:CloogleFormatResult")
  function! s:CloogleFormatResult(result)
    let rtype = a:result[0]
    let rloc = a:result[1][0]
    let rextra = a:result[1][1]
    if exists("rloc.builtin") && rloc.builtin == 1
      let locstring = 'builtin'
    else
      let locstring = rloc.modul . ' in ' . rloc.library
    endif
    let extrastring = []
    if rtype == 'FunctionResult'
      let extrastring = [rextra.func]
    elseif rtype == 'TypeResult'
      let extrastring = split(rextra.type, "\n")
    elseif rtype == 'ClassResult'
      let extrastring = ['class ' . rextra.class_heading . ' where']
      for class_fun in rextra.class_funs
        let extrastring += ["\t" . class_fun]
      endfor
    elseif rtype == 'MacroResult'
      let extrastring = split(rextra.macro_representation, "\n")
    elseif rtype == 'ModuleResult'
      let extrastring = ["import " . rloc.modul]
      if rextra.module_is_core
        let extrastring[0] .= " // This is a core module"
      endif
    endif
    return ['// ' . locstring . ':'] + extrastring
  endfunction
endif

if !exists("*s:CloogleSearch")
  function! s:CloogleSearch(str)
    if executable('curl') == 0
        let g:clean#cloogle#window = ["Curl is not installed"]
    else
        let curl = g:clean_curlpath . ' -A vim-clean -G -s'
        let data = ' --data-urlencode ' . shellescape('include_core=true')
        let data .= ' --data-urlencode ' . shellescape('str=' . a:str)
        let url = shellescape('https://cloogle.org/api.php')
        let true = 1
        let false = 0
        let ret = eval(substitute(system(curl . data . ' ' . url), "\n", "", ""))
        let nr = len(ret.data)
        let total = nr
        if exists("ret.more_available")
          let total += ret.more_available
        endif
        let g:clean#cloogle#window =
              \ [ '/**'
              \ , printf(' * Cloogle search for "%s" (%d of %d result(s))',
                    \ a:str, nr, total)
              \ , ' *'
              \ , ' * For more information, see:'
              \ , ' * https://cloogle.org/#' . a:str
              \ , ' */'
              \ , ''
              \ ]
        for result in ret.data
          let g:clean#cloogle#window += s:CloogleFormatResult(result) + ['']
        endfor
    endif
    call s:CloogleWindow()
    9
  endfunction
endif

if !exists("*s:CloogleComplete")
  function! s:CloogleComplete(lead, line, pos)
    let res = []

    " Cloogle search strings
    for s in ['class', 'type', '::']
      if stridx(s, a:lead) == 0
        call add(res, s . ' ')
      endif
    endfor

    " Function names
    let text = join(getline(1, '$'), "\n")
    let matches = []
    call substitute(text, '[a-zA-Z0-9_][a-zA-Z0-9_`]\+', '\=add(matches, submatch(0))', 'g')
    let matches = uniq(sort(matches))
    for name in matches
      if stridx(name, a:lead) == 0
        call add(res, name)
      endif
    endfor

    return res
  endfunction
endif

command! -complete=customlist,<SID>CloogleComplete -nargs=+ Cloogle :call <SID>CloogleSearch(<q-args>)
command! CloogleWindow :call <SID>CloogleWindow()

map <buffer> <LocalLeader>c :call <SID>CloogleSearch(expand('<cword>'))<CR>

let b:all_tag_files = split(globpath('./Clean\ System\ Files/ctags', '*_tags'), '\n')
for b:tag_file_name in b:all_tag_files
  exec "set tags+=" . substitute(b:tag_file_name, "Clean System Files", "Clean\\\\\\\\\\\\\ System\\\\\\\\\\\\ Files", "") . ";"
endfor

let &cpo = s:cpo_save
unlet s:cpo_save

" vim: expandtab shiftwidth=2 tabstop=2
