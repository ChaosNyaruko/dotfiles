# Comparisons  
case-sensitive comparisons  
==? ==#   
:h expr4  
never use ==  
""  
# Functions  
unscoped function should start with a capital letter  
:h :call  
:h E124  
:h return  
  
# Function Arguments  
echom a:name  
your always need to prefix those arguments with `a:`  
## Varargs  
function Varg(...)  
    a:0 number of extra arguments  
    a:1  
    a:2  
    a:000 a list containing all the extra arguments  
  
can't use echom with a list, but seems testing is passed.  
can't reassign argument variables  
  
:h function-argument  
:h local-variables  
  
# Numbers  
recommend avoiding the use of octal numbers when possible  
:h Float  
:h floating-point-precision  
  
# Strings  
Vim's `+` operator is only for Numbers(not including Floats), not for Strings.  
String concatenation operator `.`  
  
Two single quotes in a row is the **only** sequence that has special meaning in a literal string.  
  
:h expr-quote  
:h i_CTRL-V  
:h literal-string  
  
# String Functions  
strlen("foo")  
    notice: len()  
:h split()  
:h join()  
split and join can be paired to great effect.  
tolower()  
toupper()  
:h functions  
  
# Execute  
```  
:execute "rightbelow vsplit " . bufname("#")  
```  
In most programming languages the use of such an "eval" construct to evaluate strings as program code is frowned upon (to put it lightly). Vimscript's execute command doesn't have the same stigma for two reasons.  
  
:h execute  
:h rightbelow  
:h leftabove  
:h split  
:h vsplit  
  
# Normal  
normal! always use `!`   
normal(!) doesn't take/parse special characters such as <cr> etc.  
:h normal  
## Extra Credit  
:h helpgrep  
  
# Execute Normal!  
```  
:execute "normal! gg/foo\<cr>dd"  
```  
:h expr-quote  
  
know how to using string escapes to pass special characters to normal! with execute  
  
# Basic Regular Expressions  
[regex](https://learncodethehardway.org/)  
vanilla Vim/Emacs  
:help magic  
:help pattern-overview  
:help :match  
:match none  
:match group /pattern/  
:h nohlsearch  
:nohls vs :set nohls  
  
# Case Study: Grep Operator, Part One  
## Grep  
:h :grep  
:h :make  
:h quickfix-window  
  
## Refine  
<cword> <cWORD>  
:h escape()  
:h shellescape()  
:h silent  
:h cword  
  
# Case Study: Grep Operator, Part Two  
put it in ~/.vim/plugin  
:h visualmode()  
:h c_ctrl-u  
:h operatorfunc  
:h map-operator  
  
# Case Study: Grep Operator, Part Three  
:h <SID>  
  
# Lists  
zero-indexed  
-1: the last element -2: the second-to-last  
  
slicing: [0:2] both included  
  
strings can be indexed and sliced too  
  
use + to concatenate  
  
add()  
len()  
get()  
index()  
join()  
reverse()  
:help List  
:match Keyword  
:h highlight  
  
# Looping  
## For Loops  
There's no equivalent to the C-style `for (int i = 1;i < foo; i++)`  
  
## While Loops  
  
:h for  
:h while  
  
# Dictionaries  
  
Always use the trailing comma in your dictionaries  
  
index: Vim coerce the index to a string before performing the lookup.  
Javascript-style "dot" is allowed  
  
remove()  
unlet  
  
get()  
has_key()  
items()  
keys()  
values()  
:h Dictionary  
  
# Toggle  
  
```  
nnoremap <leader>f :call FoldColumnToggle()<cr>  
  
function! FoldColumnToggle()  
    if &foldcolumn  
        setlocal foldcolumn=0  
    else  
        setlocal foldcolumn=4  
    endif  
endfunction  
```  
  
This illustrates an important point about writing Vimscript code: if you try to handle every single edge case you'll get bogged down in it and never get any work done.  
  
Getting something that works most of the time (and doesn't explode when it doesn't work) and getting back to coding is usually better than spending hours getting it 100% perfect. The exception is when you're writing a plugin you expect many people to use. In that case it's best to spend the time and make it bulletproof to keep your users happy and reduce bug reports.  
  
```  
nnoremap <leader>q :call QuickfixToggle()<cr>  
  
let g:quickfix_is_open = 0  
  
function! QuickfixToggle()  
    if g:quickfix_is_open  
        cclose  
        let g:quickfix_is_open = 0  
    else  
        copen  
        let g:quickfix_is_open = 1  
    endif  
endfunction  
```  
:h foldcolumn  
:h winnr()  
:h ctrl-w_w  
:h wincmd  
  
# Functional Programming  
:h sort()  
:h reverse()  
:h copy()  
:h deepcopy()  
:h map()  
:h function()  
  
# Paths  
:echom expand('%')  
:echom expand('%:p')  
:echom fnamemodify('foo.txt', ':p')  
:echo globpath('.', '*')  
:echo split(globpath('.', '*'), '\n')  
:echo split(globpath('.', '**'), '\n')  
:h expand()  
:h fnamemodify()  
:h filename-modifiers  
:h simplify()  
:h resolve()  
:h globpath()  
:h wildcards  
  
# Plugin Layout in the Dark Ages  
~/.vim/colors/  
~/.vim/plugin/  
~/.vim/ftdetect/  
~/.vim/ftplugin/  
~/.vim/indent/  
~/.vim/compiler/  
~/.vim/after/  
~/.vim/autoload/  
~/.vim/doc/  
  
# A New Hope: Plugin Layout with Pathogen  
:h runtimepath  
  
# Detecting Filetypes  
:h ft  
:h setfiletype  
`setfiletype` instead of `set filetype`  
  
:h packadd  
:h runtimepath  
:h path  
for ftdetect issues  
  
# Basic Syntax Highlighting  
We'll ignore the `if` and `let` boilerplate at the beginning and end of the file.  
:h syn-keyword  
:h iskeyword  
:h group-name  
  
# Advanced Syntax Highlighting  
groups defined later have priority over groups defined earlier.  
:h syn-match  
:h syn-priority  
  
# Even More Advanced Syntax Highlighting  
For more `:h syntax` and look at syntax files other people have made.  
:h syn-region  
  
# Basic Folding  
:h usr_28  
manual/marker/diff/expr/indent  
Run ftplugin's scripts whenever it sets a buffer's `filetype` to `potion`(because it's in a folder named `potion`)  
  
:h foldmethod  
:h fold-manual  
:h fold-marker  
:h foldmarker  
:h fold-indent  
:h fdl  
:h foldlevelstart  
:h foldminlines  
:h foldignore  
  
# Advanced Folding  
Each line of code in a file has a "foldlevel". This is always either zero or a positive integer.  
Lines with a foldlevel of zero are never included in any fold.  
Adjacent lines with the same foldlevel are folded together.  
If a fold of level X is closed, any subsequent lines with a foldlevel greater than or equal to X are folded along with it until you reach a line with a level less than X.  
  
you can simply run :set ft=potion in the split containing factorial.pn and Vim will reload the folding code!  
  
:h foldexpr  
:h fold-expr  
:h getline  
:h indent()  
:h line()  
  
# Section Movement Theory  
:h section  
:h sections  
[[ ]] opening braces  
[] ][ closing braces   
or some similar concepts/marks  
  
# Potion Section Movement  
\<script\> <slient> <buffer>    
:h line-continuation    
:h %^ // vim regex: beginning of file    
:h search()    
:h ordinary-atom    
  
# External Commands  
:silent !  vs :silent!  
:redraw!  
system()  
append()  
split()  
a "scratch" split  
:h bufname  
:h buftype  
:h append()  
:h split()  
:h :!  
:h :read  
:h :read!  
:h system()  
:h design-not  
:help bufwinnr()  
  
# Autoloading  
:help autoload  
:h silent  
  
# Documentaion  
:h help  
:set filetype=help  
figlet -f ogre "Potion"  
The ~ characters at the end of the lines ensure that Vim doesn't try to highlight or hide individual characters inside the art.  
:helptags to tell Pathogen to rebuild the index of help tags  
:h help-writing  
:h :left  
:h :right  
:h :center  
  
# Distribution  
  
# What Now?  
## Color Schemes  
:h highlight  
  
## The Command Command  
:help user-commands  
  
## runtimepath  
:h runtimepath  
  
## Omnicomplete  
:help ins-completion  
:h omnifunc  
:h compl-omni  
  
## Compiler Support  
:h quickfix.txt  
However, I will warn you now that errorformat is not for the faint of heart!  
  
## Other Languages  
:h Python  
:h Ruby  
:h Lua  
:h perl-using  
:h MzScheme  
  
## Vim's Documentation  
:h various-motions  
:h sign-support  
:h map-alt-keys  
:h error-messages  
:h development  
:h virtualedit  
:h tips  
:h 24.8  
:h 24.9  
:h usr_12.txt  
:h usr_26.txt  
:h usr_32.txt  
:h usr_42.txt    
