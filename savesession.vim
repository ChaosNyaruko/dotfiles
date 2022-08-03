" functions for FN key to manage vim session
function! FKeySessionFunc(key, os)
    if a:os == "Darwin"
        let file_path_prefix = system("echo -n ~/workplace/tmp/vim_session_") . trim(system("md5 -qs " . trim(system("pwd")))) . "_"
    elseif a:os == "Linux"
        let file_path_prefix = "/tmp/vim_session_" . trim(system("echo -n " . trim(system("pwd")) . " | md5sum | awk '{print $1}'")) . "_"
    endif

    if a:key <= 12
        let files = system("ls " . file_path_prefix . "*")
        let sessions = split(files, file_path_prefix)
        let sessions_count = len(sessions)
        let hints = ""
        let i = 0
        while i < sessions_count
            let sessions[i] = trim(sessions[i])
            let hints .= i . ": " . sessions[i] . "\n"
            let i += 1
        endwhile
        if a:key == 10 " delete
            call inputsave()
            let user_input = trim(input(hints . "delete_session: "))
            call inputrestore()
            if user_input =~# '^\d\+$' && user_input < sessions_count
                execute "silent !rm -f " . file_path_prefix . sessions[user_input]
            elseif user_input != ""
                execute "silent !rm -f " . file_path_prefix . user_input
            endif
        elseif a:key == 11 " save
            call inputsave()
            let user_input = trim(input(hints . "save_session: "))
            call inputrestore()
            if user_input =~# '^\d\+$' && user_input < sessions_count
                execute "mks! " . file_path_prefix . sessions[user_input]
            elseif user_input != ""
                execute "mks! " . file_path_prefix . user_input
            endif
        elseif a:key == 12 " load
            call inputsave()
            let user_input = trim(input(hints . "load_session: "))
            call inputrestore()
            if user_input =~# '^\d\+$' && user_input < sessions_count
                execute "so " . file_path_prefix . sessions[user_input]
            elseif user_input != ""
                execute "so " . file_path_prefix . user_input
            endif
        endif
    elseif a:key == 13
        execute "mks! " . file_path_prefix . "0_exit_save"
    endif

endfunction

let os = substitute(system('uname'), "\n", "", "")
nmap <F10> :call FKeySessionFunc(10, os)<CR>
nmap <F11> :call FKeySessionFunc(11, os)<CR>
nmap <F12> :call FKeySessionFunc(12, os)<CR>
" save workspace before leaving
autocmd VimLeave * call FKeySessionFunc(13, os)
