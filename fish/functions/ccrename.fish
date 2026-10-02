function ccrename
    echo "???"
    if test (count $argv) -gt 0; and string match -q -- "run" $argv[1]
        eza 2026* | tail -1 | string replace -r '\.[^.]*$' '' | xargs -I{} echo {}.mkv '-->' {}_TODO.mkv
        set -l confirm (read -P 'confirmed? (yes/No)')
        echo "confirm = $confirm"
        if test $confirm = 'yes'
            eza 2026* | tail -1 | string replace -r '\.[^.]*$' '' | xargs -I{} mv -v {}.mkv {}_TODO.mkv
        end
    else
        echo -n "dry run:  "
        eza 2026* | tail -1 | string replace -r '\.[^.]*$' '' | xargs -I{} echo {}.mkv '-->' {}_TODO.mkv
    end
end

