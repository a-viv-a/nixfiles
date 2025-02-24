function wp_setdefault
    set id (wp_findnodes | fzf -d '\t' -n '2,3' --bind 'enter:become(echo {1})')
    if [ $status -eq 0 ]
        wpctl set-default $id
    end
    wpctl status
    refresh_status audio
end
