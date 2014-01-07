if !exists("main_syntax")
  if version < 600
    syntax clear
  elseif exists("b:current_syntax")
    finish
  endif
  let main_syntax = 'json'
endif

syntax sync fromstart

syntax match   jsonNoise           /\%(:\|,\|\;\|\.\)/ skipwhite nextgroup=jsonString

" Program Keywords
syntax keyword jsonBooleanTrue    true
syntax keyword jsonBooleanFalse   false

" JavaScript style comments
syntax region  jsonLineComment    start=+\/\/+ end=+$+ keepend contains=jsonCommentTodo,@Spell
syntax region  jsonLineComment    start=+^\s*\/\/+ skip=+\n\s*\/\/+ end=+$+ keepend contains=@Spell fold
syntax region  jsonComment        start="/\*"  end="\*/" contains=@Spell fold

" Syntax in the JavaScript code
syntax match   jsonSpecial        "\v\\%(0|\\x\x\{2\}\|\\u\x\{4\}\|\c[A-Z]|.)"
syntax region  jsonString         start=+"+  skip=+\\\\\|\\$"+  end=+"+  contains=jsonSpecial
syntax match   jsonNumber         /\<-\=\d\+L\=\>\|\<0[xX]\x\+\>/
syntax keyword jsonNumber         Infinity NaN
syntax match   jsonFloat          /\<-\=\%(\d\+\.\d\+\|\d\+\.\|\.\d\+\)\%([eE][+-]\=\d\+\)\=\>/
syntax keyword jsonNull           null

" JSON elements
syntax cluster jsonExpression contains=jsonComment,jsonLineComment,jsonNumber,jsonFloat,jsonThis,jsonOperator,jsonBooleanTrue,jsonBooleanFalse,jsonNull,jsonCommaError
syntax cluster jsonAll        contains=@jsonExpression,jsonNoise
syntax region  jsonBracket    matchgroup=jsonBrackets     start="\[" end="\]" contains=@jsonAll,jsonString,jsonParensErrB,jsonParensErrC,jsonBracket,jsonParen,jsonBlock fold
syntax region  jsonParen      matchgroup=jsonParens       start="("  end=")"  contains=@jsonAll,jsonString,jsonParensErrA,jsonParensErrC,jsonParen,jsonBracket,jsonBlock fold
syntax region  jsonBlock      matchgroup=jsonBraces       start="{"  end="}"  contains=@jsonAll,jsonParensErrA,jsonParensErrB,jsonParen,jsonBracket,jsonBlock,jsonKey fold

" Object keys
syntax region jsonKey start=+"+ skip=+\\\\\|\\$"+ end=+"+ contains=jsonSpecial

" catch errors caused by wrong parenthesis
syntax match   jsonParensError    ")\|}\|\]"
syntax match   jsonParensErrA     contained "\]"
syntax match   jsonParensErrB     contained ")"
syntax match   jsonParensErrC     contained "}"

" catch comma errors
syn match jsonCommaError ",\_s*[}\]]"

if main_syntax == "json"
  syntax sync clear
  syntax sync ccomment jsonComment minlines=200
  syntax sync match jsonHighlight grouphere jsonBlock /{/
endif

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_json_syn_inits")
  if version < 508
    let did_json_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif
  HiLink jsonComment              Comment
  HiLink jsonLineComment          Comment
  HiLink jsonString               String
  HiLink jsonKey                  Special
  HiLink jsonParensError          Error
  HiLink jsonParensErrA           Error
  HiLink jsonParensErrB           Error
  HiLink jsonParensErrC           Error
  HiLink jsonCommaError           Error
  HiLink jsonOperator             Operator
  HiLink jsonThis                 Special
  HiLink jsonNull                 Type
  HiLink jsonNumber               Number
  HiLink jsonFloat                Float
  HiLink jsonBooleanTrue          Boolean
  HiLink jsonBooleanFalse         Boolean
  HiLink jsonNoise                Noise
  HiLink jsonBrackets             Noise
  HiLink jsonParens               Noise
  HiLink jsonBraces               Noise
  HiLink jsonSpecial              Special

  delcommand HiLink
endif

let b:current_syntax = "json"
if main_syntax == 'json'
  unlet main_syntax
endif
