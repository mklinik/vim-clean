function! cleanvim#cloogle#window()
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

function! cleanvim#cloogle#format(result)
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

function! cleanvim#cloogle#search(str)
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
        let g:clean#cloogle#window += cleanvim#cloogle#format(result) + ['']
      endfor
  endif
  call cleanvim#cloogle#window()
  9
endfunction

function! cleanvim#cloogle#complete(lead, line, pos)
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

function! cleanvim#cloogle#init()
  command! -complete=customlist,cleanvim#cloogle#complete -nargs=+ Cloogle :call cleanvim#cloogle#search(<q-args>)
  command! CloogleWindow :call cleanvim#cloogle#window()

  map <buffer> <LocalLeader>c :call cleanvim#cloogle#search(expand('<cword>'))<CR>
endfunction

" vim: expandtab shiftwidth=2 tabstop=2
