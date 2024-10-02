function powermenu
    echo "\
1 - lock
2 - screen off
3 - logout
4 - reboot
5 - uefi
6 - shutdown" | fuzzel --dmenu --lines 6 | read choice

    switch $choice
        case '*lock'
            killall -USR1 swayidle
        case '*screen off'
            killall -USR1 swayidle
            killall -USR1 swayidle
        case '*logout'
            riverctl exit
        case '*reboot'
            systemctl reboot
        case '*uefi'
            systemctl reboot --firmware-setup
        case '*shutdown'
            systemctl poweroff
    end
end
