function screenshot --description "take a screenshot"
    # set -x RUST_BACKTRACE full
    grim \
        -l 0 -g "$(slurp -o -c '#ff0000ff')" - \
        | satty --filename - --fullscreen --early-exit \
        --copy-command 'wl-copy' \
        --output-filename ~/screenshots/$(date '+%Y%m%d-%H:%M:%S').png

end
