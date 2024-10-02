{ pkgs, lib, ... }:
{
  programs.river.enable = true;
  nixpkgs.overlays = [
    (final: prev: {
      river = prev.river.overrideAttrs (old: {
        patches = (old.patches or [ ]) ++ [
          (prev.fetchpatch {
            url = "https://codeberg.org/river/river/pulls/1145.diff";
            hash = "sha256-ZCDgVmv3ZRdRfhFDovf2Yw92OeH/hfo1yohR1h/ahhA=";
          })
        ];
      });
    })
  ];
  programs.river.extraPackages = with pkgs; [
    way-displays
    wl-clipboard
    grim
    satty
    slurp
    libnotify
    sandbar
    lswt
    wob
    mako
    swayimg
    playerctl
    swaylock
    swayidle
    gnome-keyring
    seahorse
    wlopm
  ];
  environment.etc."way-displays/cfg.yaml".source = ./way-displays/cfg.yaml;
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.variables.XDG_CURRENT_DESKTOP = "river";
  environment.etc."wob/wob.ini".source = ./wob/wob.ini;

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-wlr
    ];
  };

  environment.etc."swayidle/config".source = ./lock/swayidle;
  environment.etc."swaylock/config".source = pkgs.substitute {
    src = ./lock/swaylock;
    substitutions = [
      "--replace-fail"
      "{{wallpaper}}"
      (toString ./lock/wallpaper.jpeg)
    ];
  };

  security.pam.services.swaylock = { };

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.gdm-password.enableGnomeKeyring = true;

  # networking.networkmanager.dispatcherScripts = [
  # 		{
  # 			source = pkgs.writeText "updateStatusOnChange" ''
  # 		#!/usr/bin/env ${pkgs.fish}/bin/fish
  # 		refresh_status wifi
  # 			'';
  # 			type = "basic";
  # 		}	
  # ];

  # https://nixos.wiki/wiki/Sway#Inferior_performance_compared_to_other_distributions
  security.pam.loginLimits = [
    {
      domain = "@users";
      item = "rtprio";
      type = "-";
      value = 1;
    }
  ];
}
