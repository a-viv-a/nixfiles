function refresh_status
    set status_pid_dir "$XDG_RUNTIME_DIR/status_pid"
    set needs_refresh_dir "$XDG_RUNTIME_DIR/status_needs_refresh"
    for status_item in $argv
        # mark this status item as needing immediate refresh
        touch $needs_refresh_dir/$status_item
    end
    # wake up status process early
    # this will set awoken to true
    # which will cause the refresh dir to be iterated and acted on
    pkill -P (cat $XDG_RUNTIME_DIR/status_pid) sleep
end
