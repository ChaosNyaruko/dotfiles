syntax match  ccFoobar  "Foo.\{-}Bar"  contains=ccFoo
syntax match  ccFoo     "Foo"	    contained nextgroup=ccFiller
syntax region ccFiller  start="."  matchgroup=Error  end="Bar"  contained

" Foo asdfasd Bar asdf Foo asdf Bar asdf
" Foo asdfasd Bar asdf Foo asdf Bar asdf
" Foo mm Bar
" Foo asdfasd Bar 
"

:h /\{- in pattern.txt

