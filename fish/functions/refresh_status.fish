function refresh_status --argument-names status_item value \
    -d 'refresh a status bar item by name. value may optionally be provided, otherwise status_item_fn will be run'
    set status_pid_dir "$XDG_RUNTIME_DIR/status_pid"
    set needs_refresh_dir "$XDG_RUNTIME_DIR/status_needs_refresh"
    # mark this status item as needing immediate refresh
    # if only one argument is provided this results in an empty file, triggering rerun
    echo $value >$needs_refresh_dir/$status_item
    # wake up status process early
    # this will set awoken to true
    # which will cause the refresh dir to be iterated and acted on
    pkill -P (cat $XDG_RUNTIME_DIR/status_pid) sleep
end
