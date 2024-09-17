function get_volume
    wpctl get-volume @DEFAULT_AUDIO_SINK@ \
        | rg -o ': ((?:\\d|\\.)+)' -r '$1' \
        | pmath "P * 100"
end
