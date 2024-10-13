{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:
let
  secrets_path = builtins.toString inputs.secrets-nix;
in
{
  imports = [
    ./hardware-configuration.nix
    ./persist.nix
  ];

  # This will add each flake input as a registry
  # To make nix3 commands consistent with your flake
  nix.registry = (lib.mapAttrs (_: flake: { inherit flake; })) (
    (lib.filterAttrs (_: lib.isType "flake")) inputs
  );

  # This will additionally add your inputs to the system's legacy channels
  # Making legacy nix commands consistent as well, awesome!
  nix.nixPath = [ "/etc/nix/path" ];

  environment.etc = lib.mapAttrs' (name: value: {
    name = "nix/path/${name}";
    value.source = value.flake;
  }) config.nix.registry;

  nix.settings = {
    experimental-features = "nix-command flakes";
    auto-optimise-store = true;
  };
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 60d";
  };

  nixpkgs.config.allowUnfree = true;

  networking.hostName = "blade";
  networking.networkmanager.enable = true;

  security.polkit.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # can't have more than one!
  time.timeZone = "America/Chicago";
  # services.automatic-timezoned.enable = true;
  # services.geoclue2.geoProviderUrl = "https://beacondb.net/v1/geolocate";
  # time.timeZone = "America/Los_Angeles";

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  services.tailscale.enable = true;
  services.tailscale.useRoutingFeatures = "client";

  services.avahi.enable = true;

  users.mutableUsers = false;

  users.users = {
    # password: temp a
    root.hashedPasswordFile = config.sops.secrets.root_password.path;

    aviva = {
      # password: temp b
      hashedPasswordFile = config.sops.secrets.aviva_password.path;
      extraGroups = [
        "wheel"
        "libvirtd"
      ];
      isNormalUser = true;
      shell = pkgs.fish;
    };
  };

  sops = {
    defaultSopsFile = "${secrets_path}/secrets.yaml";
    age = {
      sshKeyPaths = [ "/nix/persist/home/aviva/.ssh/id_ed25519" ];
      keyFile = "/nix/persist/home/aviva/.config/sops/age/keys.txt";
      generateKey = true;
    };
    secrets = {
      aviva_password.neededForUsers = true;
      root_password.neededForUsers = true;
    };
  };

  programs.fish.enable = true;

  environment.variables = {
    EDITOR = lib.getExe pkgs.helix;
  };

  # flash drives and such
  services.udisks2.enable = true;

  # virt manager
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  # dont show me the sudo warning every boot bc of tmpfs
  security.sudo.configFile = ''
    Defaults lecture = never
  '';

  fonts.packages = with pkgs; [
    # don't need the rest!
    # https://nixos.wiki/wiki/Fonts#Installing_specific_fonts_from_nerdfonts
    (nerdfonts.override {
      fonts = [
        "DroidSansMono"
        "Hack"
        "Iosevka"
      ];
    })
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
