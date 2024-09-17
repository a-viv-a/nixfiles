function set_brightness -a offset
    set backlight "/sys/class/backlight/amdgpu_bl2"

    set max_value (cat $backlight/max_brightness)
    set value (math "min(max($(cat $backlight/brightness) $offset, 0), $max_value)")
    echo $value > $backlight/brightness \
        && math -s 0 "$value / $max_value * 100" \
        > /tmp/wob

    refresh_status brightness
end
