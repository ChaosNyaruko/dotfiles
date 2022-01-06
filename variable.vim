let foo="bar"
echo foo

let foo= 42
echo foo

"options as variables
set textwidth=80
echo &textwidth 
" ampersand
"
set nowrap
echo &wrap

let &textwidth=100
set textwidth?
let &textwidth=&textwidth+100
set textwidth?

" local options
let &l:number = 1
let &l:number = 0

" registers as variables
let @a = "hello"
echo @a
echo @"
echo @/

let &l:number="111" " no use 
let &l:number=111 " no use 

" You should never use let if set will suffice -- it's harder to read.
" :help registers
