function set_volume -a value
    wpctl set-volume @DEFAULT_AUDIO_SINK@ "$value"
    display_volume
end
