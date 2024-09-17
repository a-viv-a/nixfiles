function delta
    sudo whoami
    sudo rsync -amvxx \
      --dry-run \
      --no-links \
      --exclude '/tmp/*' \
      --exclude '/root/*' \
      / /nix/persist/ \
      | rg -v '^skipping|/$' \
      | tail --lines +2 \
      | head --lines -3 \
      | fzf --preview "sudo bat /{}"
end
