function display_volume
    if is_muted
        echo "$(get_volume) muted" > /tmp/wob
    else
        get_volume > /tmp/wob
    end
    refresh_status audio
end
