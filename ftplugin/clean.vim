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

if !exists("g:clean_highlight_o")
  let g:clean_highlight_o = 1
endif

if g:clean_folding
  if !exists("*CleanFoldLevel")
    function CleanFoldLevel()
      let line=getline(v:lnum)

      if line =~ '^\s*/[/*]' || line =~ '^\s*$' " Comments
        return -1
      elseif line =~ '^\s*}' " Code blocks; layout insensitive style
        return '='
      elseif line =~ '^\t* ' " Space indenting: not for indent but for =-matching or so
        return '='
      endif

      let level = indent(v:lnum) / &shiftwidth

      if line =~ '^\s*\(where\|with\|::\)' " Local definitions
        return '>' . (level+1)
      endif

      return level
    endfunction
  endif

  if !exists("*CleanFoldText")
    function CleanFoldText()
      let line = v:foldstart

      let prefix = ''
      while getline(line) =~ '^\s*\(where\|with\|//\|/\*\)\s*$'
        let strline = getline(line)
        if strline =~ '^\s*\(where\|with\)\s*$'
          let prefix .= strline
        endif
        let line += 1
      endwhile

      let header = prefix . getline(line) . ' ...'
      let tabstospaces = '\=repeat(" ", ' . &shiftwidth . ' * len(submatch(0)))'
      let header = substitute(header, '^\t\+', tabstospaces, 'g')
      let header = substitute(header, '\(\S\)\s\+', '\1 ', 'g')
      return v:folddashes . substitute(header, '^\s\{,' . len(v:folddashes) . '}', '', '')
    endfunction
  endif

  setlocal foldexpr=CleanFoldLevel()
  setlocal foldtext=CleanFoldText()
  setlocal foldminlines=2
  setlocal foldignore=
  setlocal foldmethod=expr
endif

if !exists("*s:CleanSwitchModule")
  function s:CleanSwitchModule(cmd)
    let basename = expand("%:r")
    let filename = basename . (expand('%:e') == 'icl' ? '.dcl' : '.icl')

    " Check if the file is already open
    let thebuff = bufnr(filename)
    if thebuff != -1
      let thewins = win_findbuf(thebuff)
      if len(thewins) > 0
        call win_gotoid(thewins[0])
        return
      endif
    endif

    " Not open in a window, open a new one
    let oldbuf = bufname('%')
    exec a:cmd . ' ' . filename

    if g:clean_autoheader && !filereadable(filename)
      let modrgx = '\(implementation\|definition\)\?\s*module\s\+'
      let line = matchstr(getbufline(oldbuf, 1, '$'), modrgx)
      if line != ''
        let modname = substitute(line, '\(implementation\|definition\|module\|\s\+\)', '', 'g')
      else
        let modname = substitute(basename, '/', '.', 'g')
      endif
      let header = expand('%:e') == 'dcl' ? 'definition' : 'implementation'
      exec 'normal i' . header . ' module ' . modname . "\<CR>\<CR>\<Esc>"
    endif
  endfunction
endif

command! -nargs=1 CleanSwitchModule :call <SID>CleanSwitchModule(<args>)
map <buffer> <LocalLeader>mm :call <SID>CleanSwitchModule('edit')<CR>
map <buffer> <LocalLeader>mt :call <SID>CleanSwitchModule('tabedit')<CR>
map <buffer> <LocalLeader>ms :call <SID>CleanSwitchModule('split')<CR>
map <buffer> <LocalLeader>mv :call <SID>CleanSwitchModule('vsplit')<CR>

if !exists("*s:CleanAddImport")
  " Add an import at an appropriate place in the file. a:search is the thing
  " to sort on (the module name); a:import the actual import string. The
  " import string is added below the last 'import ...' line that comes
  " alphabetically before the import string.
  function! s:CleanAddImport(search, import)
    let lastline = 2
    let lineno = 0
    for line in getline('1', '$')
      let lineno += 1
      let ip = matchlist(line, '^import \(\S\+\)')
      if len(ip) > 0
        if ip[1] < a:search
          let lastline = lineno
        elseif ip[1] == a:search
          echohl WarningMsg | echomsg a:search . ' is already imported.' | echohl None
          return
        else
          call append(lastline, a:import)
          call cursor(lastline+1, 1)
          return
        endif
      endif
    endfor
    call append(lastline, a:import)
    call cursor(lastline+1, 1)
  endfun
endif

if !exists("*s:CleanTagSort")
  function! s:CleanTagSort(taga, tagb)
    if a:taga.module < a:tagb.module
      return -1
    elseif a:taga.module == a:tagb.module
      return 0
    else
      return 1
    endif
  endfun
endif

if !exists("*s:CleanAutoImport")
  " Auto-import 'str' by looking at the tag list. When selective is 1, use a
  " 'from ... import ...' import.
  function! s:CleanAutoImport(str, selective)
    " Split record field names
    let str = a:str
    if a:str =~ '\([a-zA-Z_`]\+\.\)\+[a-zA-Z_`]\+'
      let col = getpos('.')[2]
      let line = getline('.')
      if !(line =~ '^import\>' || line =~ '^from\>.*\<import\>')
        let parts = split(a:str, '\.')
        let i = col
        echo parts
        while strpart(line, i, len(a:str)) != a:str
          let i -= 1
        endwhile
        for part in parts
          let i += len(part)
          if i > col
            let str = part
            echo [col, i, part]
            break
          endif
        endfor
      endif
    endif

    let results = filter(taglist('^\V' . str . '\$'), 'has_key(v:val, "module")')

    if len(results) == 0
      echohl WarningMsg | echomsg "No tag found for '" . str. "' (did you use cloogletags -c?)." | echohl None
      return
    elseif len(results) == 1
      let result = results[0]
    else
      call sort(results, 's:CleanTagSort')

      let resulttexts = ['Select module to import:']
      let i = 0
      for result in results
        let i += 1
        call add(resulttexts, i . ': ' . result.module)
      endfor

      let choice = inputlist(resulttexts)
      if choice <= 0
        return
      endif
      let result = results[choice-1]
    endif

    if a:selective
      let import = 'from ' . result.module . ' import '
      if result.thing == 'function' || result.thing == 'macro'
        let import .= result.name
      elseif result.thing == 'generic'
        let import .= 'generic ' . result.name
      elseif result.thing == 'constructor'
        let import .= ':: ' . result.type . '(' . result.name . ')'
      elseif result.thing == 'recfield'
        let import .= ':: ' . result.type . '{' . result.name . '}'
      elseif result.thing == 'type'
        let import .= ':: ' . result.name
      elseif result.thing == 'class'
        let import .= 'class ' . result.name
      elseif result.thing == 'classmem'
        let import .= 'class ' . result.class . '(' . result.name . ')'
      endif
    else
      let import = 'import ' . result.module
    endif

    call s:CleanAddImport(result.module, import)
  endfun
endif

map <buffer> <LocalLeader>ai :call <SID>CleanAutoImport(expand('<cword>'), 0)<CR>
map <buffer> <LocalLeader>aI :call <SID>CleanAutoImport(expand('<cword>'), 1)<CR>

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
    if executable(g:clean_curlpath) == 0
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

let &cpo = s:cpo_save
unlet s:cpo_save

" vim: expandtab shiftwidth=2 tabstop=2
