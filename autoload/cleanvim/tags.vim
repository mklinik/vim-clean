function! cleanvim#tags#sort(taga, tagb)
  if a:taga.module < a:tagb.module
    return -1
  elseif a:taga.module == a:tagb.module
    return 0
  else
    return 1
  endif
endfun

function! cleanvim#tags#choosemodule(msg, tag)
  let results = filter(taglist('^\V' . a:tag . '\$'), 'has_key(v:val, "module")')

  if len(results) == 0
    echohl WarningMsg
    echomsg "No tag found for '" . a:tag. "' (did you use cloogletags -c?)."
    echohl None
    return {}
  elseif len(results) == 1
    return results[0]
  else
    call sort(results, 'cleanvim#tags#sort')

    let resulttexts = [a:msg]
    let i = 0
    for result in results
      let i += 1
      call add(resulttexts, i . ': ' . result.module)
    endfor

    let choice = inputlist(resulttexts)
    if choice <= 0
      return {}
    endif

    return results[choice-1]
  endif
endfun

function! cleanvim#tags#jump(str, cmd, implementation)
  let result = s:CleanChooseModuleForTag('Select module to load:', a:str)
  if result == {}
    return
  endif

  if a:implementation
    if has_key(result, 'icl')
      exec a:cmd . ' ' . substitute(result.filename, '\.dcl$', '.icl', '')
      exec result.icl
      return
    else
      call confirm('No implementation for this element; jumping to dcl instead...')
    endif
  endif
  exec a:cmd . ' ' . result.filename
  exec result.cmd
endfun

function! cleanvim#tags#init()
  map <buffer> <LocalLeader>dd :call cleanvim#tags#jump(expand('<cword>'), 'edit',    0)<CR>
  map <buffer> <LocalLeader>dt :call cleanvim#tags#jump(expand('<cword>'), 'tabedit', 0)<CR>
  map <buffer> <LocalLeader>ds :call cleanvim#tags#jump(expand('<cword>'), 'split',   0)<CR>
  map <buffer> <LocalLeader>dv :call cleanvim#tags#jump(expand('<cword>'), 'vsplit',  0)<CR>
  map <buffer> <LocalLeader>ii :call cleanvim#tags#jump(expand('<cword>'), 'edit',    1)<CR>
  map <buffer> <LocalLeader>it :call cleanvim#tags#jump(expand('<cword>'), 'tabedit', 1)<CR>
  map <buffer> <LocalLeader>is :call cleanvim#tags#jump(expand('<cword>'), 'split',   1)<CR>
  map <buffer> <LocalLeader>iv :call cleanvim#tags#jump(expand('<cword>'), 'vsplit',  1)<CR>
endfun

" vim: expandtab shiftwidth=2 tabstop=2
