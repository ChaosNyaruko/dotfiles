function Varg2(foo, ...)
    echom a:foo
    echom a:0
    echom a:1
    echo a:000
endfunction

call Varg2("a", "b", "c")

function Assign(foo)
  let a:foo = "Nope"
  echom a:foo
endfunction

call Assign("test")

function AssignGood(foo)
  let foo_tmp = a:foo
  let foo_tmp = "Yep"
  echom foo_tmp
endfunction

call AssignGood("test")
