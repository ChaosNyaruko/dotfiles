if exists("b:current_syntax")
    finish
endif

" echom "Our syntax highlighting code will go here."
syntax keyword potionKeyword loop to times while
syntax keyword potionKeyword if elsif else
syntax keyword potionKeyword class return

syntax keyword potionFunction print join string

highlight link potionKeyword Keyword
highlight link potionFunction Function

syntax match potionComment "\v#.*$"
highlight link potionComment Comment

syntax match potionOperator "\v\*"
syntax match potionOperator "\v/"
syntax match potionOperator "\v\+"
syntax match potionOperator "\v-"
syntax match potionOperator "\v\?"
syntax match potionOperator "\v\="
syntax match potionOperator "\v\*\="
syntax match potionOperator "\v/\="
syntax match potionOperator "\v\+\="
syntax match potionOperator "\v-\="

highlight link potionOperator Operator

syntax match potionNumber "\v0x[0-9]+"
highlight link potionNumber Number

let b:current_syntax = "potion" " it can be accessed after loading *.pn
