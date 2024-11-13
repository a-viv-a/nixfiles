function fix_sound
    set fish_trace 1
    systemctl --user restart wireplumber pipewire pipewire-pulse
    wpctl status
end
