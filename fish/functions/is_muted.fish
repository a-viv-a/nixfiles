function is_muted
    wpctl get-volume @DEFAULT_AUDIO_SINK@ | rg '[MUTED]' > /dev/null
    return $status
end
