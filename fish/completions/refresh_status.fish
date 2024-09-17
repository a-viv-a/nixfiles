complete -c refresh_status -f
set status_items (bat .config/river/status | rg '^function (\w+)_fn' -r '$1')
complete -c refresh_status -a "$status_items"
