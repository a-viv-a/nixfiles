complete -c refresh_status -f
set status_items (bat ~/.config/river/status | rg '^function (\w+)_fn' -r '$1')
complete -c refresh_status -n "not __fish_seen_subcommand_from $status_items" -a "$status_items"
