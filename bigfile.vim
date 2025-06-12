" https://v2ex.com/t/1138033#reply27
let g:LargeFile = 0.3 "in megabyte
augroup LargeFile
au!
au BufReadPre *
\let f=expand("<afile>")
\|if getfsize(f) >= g:LargeFile*1023*1024 || getfsize(f) <= -2
\|let b:eikeep = &ei
\|let b:ulkeep = &ul
\|let b:bhkeep = &bh
\|let b:fdmkeep= &fdm
\|let b:swfkeep= &swf
\|set ei=FileType
\|setlocal noswf bh=unload fdm=manual
\|let f=escape(substitute(f,'\','/','g'),' ')
\|exe "au LargeFile BufEnter ".f." set ul=-1"
\|exe "au LargeFile BufLeave ".f." let &ul=".b:ulkeep."|set ei=".b:eikeep
\|exe "au LargeFile BufUnload ".f." au! LargeFile * ". f
\|echomsg "***note*** handling a large file"
\|endif
au BufReadPost *
\if &ch < 2 && getfsize(expand("<afile>")) >= g:LargeFile*1024*1024
\|echomsg "***note*** handling a large file"
\|endif
augroup END
