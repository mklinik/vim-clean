function! cleanvim#fold#level()
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

function! cleanvim#fold#text()
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

function! cleanvim#fold#init()
  setlocal foldexpr=cleanvim#fold#level()
  setlocal foldtext=cleanvim#fold#text()
  setlocal foldminlines=2
  setlocal foldignore=
  setlocal foldmethod=expr
endfun

" vim: expandtab shiftwidth=2 tabstop=2
