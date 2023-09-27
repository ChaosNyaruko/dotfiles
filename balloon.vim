" It seems that balloon can only take effect in an async expr, really strange.
" May be popup is better, in neovim float-windows
" refs:
" https://github.com/vim/vim/issues/2948
" https://github.com/vim/vim/issues/2352
" https://github.com/vim/vim/issues/4063
" https://github.com/vim/vim/issues/2481
let s:counter = 0
let s:timer = -1

function! MyBalloonExpr()
  let s:counter += 1
  call timer_stop( s:timer )
  let s:message =
          \ 'Cursor is at line ' . v:beval_lnum .
          \', column ' . v:beval_col .
          \ ' of file ' .  bufname(v:beval_bufnr) .
          \ ' on word "' . v:beval_text . '"'
  return s:message
endfunction

set mouse=a
set ttymouse=sgr
" set balloonexpr=MyBalloonExpr()
set balloondelay=250
set ballooneval
set balloonevalterm

func GetBalloonContent()
   " ... initiate getting the content
   return 'okok'
endfunc

set balloonexpr=GetBalloonContent()

func BalloonCallback(result)
  call balloon_show(a:result)
endfunc

" call BalloonCallback("are you ok, lilei")

function Dummy()
  " enable balloon_show()
  call timer_stop(0)
  return "ha, I'm ok"
endfunction
set balloonexpr=Dummy()

" call balloon_show("haha")
" call balloon_show("haha")
" call balloon_show("haha")


" Returns either the contents of a fold or spelling suggestions.
function! BalloonExpr()
  let foldStart = foldclosed(v:beval_lnum )
  let foldEnd = foldclosedend(v:beval_lnum)
  let lines = []
  if foldStart < 0
    " We're not in a fold.
    " If 'spell' is on and the word pointed to is incorrectly spelled,
    " the tool tip will contain a few suggestions.
    let lines = spellsuggest( spellbadword( v:beval_text )[ 0 ], 5, 0 )
  else
    let numLines = foldEnd - foldStart + 1
    " Up to 31 lines get shown okay; beyond that, only 30 lines are shown with
    " ellipsis in between to indicate too much. The reason why 31 get shown ok
    " is that 30 lines plus one of ellipsis is 31 anyway.
    if ( numLines > 31 )
      let lines = getline( foldStart, foldStart + 14 )
      let lines += [ '-- Snipped ' . ( numLines - 30 ) . ' lines --' ]
      let lines += getline( foldEnd - 14, foldEnd )
    else
      let lines = getline( foldStart, foldEnd )
    endif
  endif
  return join( lines, has( "balloon_multiline" ) ? "\n" : " " )
endfunction
" set balloonexpr=BalloonExpr()
