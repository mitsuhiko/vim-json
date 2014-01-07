if exists("b:did_indent")
    finish
endif
let b:did_indent = 1

setlocal nolisp
setlocal autoindent
setlocal indentexpr=JSONIndent(v:lnum)
setlocal indentkeys+=<:>,0=},0=)

if exists("*JSONIndent")
  finish
endif

function! JSONIndent(lnum)
  let prevlnum = prevnonblank(a:lnum-1)
  if prevlnum == 0
    " top of file
    return 0
  endif

  " grab the previous and current line, stripping comments.
  let prevl = substitute(getline(prevlnum), '//.*$', '', '')
  let thisl = substitute(getline(a:lnum), '//.*$', '', '')
  let previ = indent(prevlnum)

  let ind = previ

  if prevl =~ '[({]\s*$'
    " previous line opened a block
    let ind += &sw
  endif

  if thisl =~ '^\s*[)}]'
    " this line closed a block
    let ind -= &sw
  endif

  return ind
endfunction
