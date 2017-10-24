" Add an import at an appropriate place in the file. a:search is the thing
" to sort on (the module name); a:import the actual import string. The
" import string is added below the last 'import ...' line that comes
" alphabetically before the import string.
function! cleanvim#imports#add(search, import)
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

" Auto-import 'str' by looking at the tag list. When selective is 1, use a
" 'from ... import ...' import.
function! cleanvim#imports#auto(str, selective)
  let result = cleanvim#tags#choosemodule('Select module to import:', a:str)
  if result == {}
    return
  endif

  if a:selective
    let import = 'from ' . result.module . ' import '
    if result.thing == 'function' || result.thing == 'rule'
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
    else
      echoerr "Unknown tag type '" . result.thing . "'"
    endif
  else
    let import = 'import ' . result.module
  endif

  call cleanvim#imports#add(result.module, import)
endfun

function! cleanvim#imports#init()
  map <buffer> <LocalLeader>ai :call cleanvim#imports#auto(expand('<cword>'), 0)<CR>
  map <buffer> <LocalLeader>aI :call cleanvim#imports#auto(expand('<cword>'), 1)<CR>
endfun

" vim: expandtab shiftwidth=2 tabstop=2
