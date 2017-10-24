function! cleanvim#modules#switch(cmd)
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

function! cleanvim#modules#init()
  command! -nargs=1 CleanSwitchModule :call cleanvim#modules#switch(<args>)
  map <buffer> <LocalLeader>mm :call cleanvim#modules#switch('edit')<CR>
  map <buffer> <LocalLeader>mt :call cleanvim#modules#switch('tabedit')<CR>
  map <buffer> <LocalLeader>ms :call cleanvim#modules#switch('split')<CR>
  map <buffer> <LocalLeader>mv :call cleanvim#modules#switch('vsplit')<CR>
endfunction

" vim: expandtab shiftwidth=2 tabstop=2
