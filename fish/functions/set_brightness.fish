function set_brightness -a offset
    set backlight_base "/sys/class/backlight"

    if test -e "$backlight_base/amdgpu_bl1"
        set backlight "$backlight_base/amdgpu_bl1"
    else if test -e "$backlight_base/amdgpu_bl2"
        set backlight "$backlight_base/amdgpu_bl2"
    else
        echo "Error: No backlight device found" >&2
        return 1
    end

    set max_value (cat $backlight/max_brightness)
    set value (math "min(max($(cat $backlight/brightness) $offset, 0), $max_value)")
    echo $value > $backlight/brightness \
        && math -s 0 "$value / $max_value * 100" \
        > /tmp/wob

    refresh_status brightness
end
