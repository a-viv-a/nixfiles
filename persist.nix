# https://github.com/nix-community/impermanence#module-usage
{
  environment.persistence."/nix/persist" = {
    hideMounts = true;
    directories = [
      "/var/log"
      "/var/lib/systemd"
      "/etc/NetworkManager/system-connections"
      # critical for nix to work right lol
      "/var/lib/nixos"
      # virtual machine drives
      "/var/lib/libvirt/images"
      "/var/lib/libvirt/qemu"
      "/var/lib/bluetooth"
      "/var/lib/tailscale"
    ];
    files = [
      # machine-id is used by systemd for the journal, if you don't persist this
      # file you won't be able to easily use journalctl to look at journals for
      # previous boots.
      "/etc/machine-id"
    ];
    users.aviva = {
      directories = [
        # where we configure nix!
        "nixos"
        # secrets right in the home
        "secrets_nix"
        # the keys to the... the something
        ".config/sops/"
        # the key to the keys
        ".ssh"
        # ".local/share/kscreen"
        # ".local/share/kwalletd"
        # ".local/share/sddm"
        ".local/share/zoxide"
        ".local/share/direnv/allow"
        # fish history, just persisting the history file causes issues
        # https://github.com/fish-shell/fish-shell/issues/10730
        ".local/share/fish/"
        # sioyek db, history of documents
        ".local/share/sioyek"
        # its a tossup but i like my cache sticking around!
        ".cache/"
        "downloads"
        "documents"
        "music"
        "raw_music"
        "screenshots"
        "repos"
        # TODO: use nix magic to keep this lined up with syncthing folders
        "garden"
        # google is a mess otherwise
        ".config/google-chrome/"
        # same deal
        ".config/spotify/"
        ".config/vesktop/"
        ".config/beets/"
        ".config/obsidian/"
      ];
      files = [
        # pem cert for eduroam
        ".config/cat_installer/ca.pem"
      ];
    };
  };
}
