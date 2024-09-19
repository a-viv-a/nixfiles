{ pkgs, lib, ... }:
{
  programs.river.enable = true;
  environment.systemPackages = with pkgs; [
    way-displays
    wl-clipboard
    grim
    satty
    slurp
    libnotify
    sandbar
    lswt
    wob
    swayimg
    playerctl
    swaylock
    swayidle
    gnome-keyring
    seahorse
  ];
  environment.etc."way-displays/cfg.yaml".source = ./way-displays/cfg.yaml;
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.etc."wob/wob.ini".source = ./wob/wob.ini;

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
