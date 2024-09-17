function fuzzykill --description "fuzzy find and kill process"
    set process (ps -e | awk '!s[$4]++ { print $4 }' | tail -n +2 | fzf --multi)
    if test -z "$process"
        echo "No process selected"
        return 1
    end
    echo "Selected process: $process"

    read -p "echo \"Kill process? (Y/n)\"" -l confirm

    if test "$confirm" = n -o "$confirm" = N
        echo "Aborted."
        return 1
    end

    echo "Killing process..."

    killall -KILL $process

    if test "$status" -eq 0
        echo "Kill confirmed."
        return 0
    else
        echo "May have failed to kill all processes."
        return $status
    end
end
