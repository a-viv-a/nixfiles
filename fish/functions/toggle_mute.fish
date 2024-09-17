function toggle_mute
    wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
    display_volume
end
