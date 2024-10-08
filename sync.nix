{ pkgs, lib, ... }:
{
  services.syncthing = {
    enable = true;
    user = "aviva";
    dataDir = "/home/aviva/documents";
    configDir = "/home/aviva/documents/.config/syncthing";
    # overrideDevices = true;     # overrides any devices added or deleted through the WebUI
    # overrideFolders = true;     # overrides any folders added or deleted through the WebUI
    # settings = {
    #   devices = {
    #     "device1" = { id = "DEVICE-ID-GOES-HERE"; };
    #     "device2" = { id = "DEVICE-ID-GOES-HERE"; };
    #   };
    #   folders = {
    #     "Documents" = {         # Name of folder in Syncthing, also the folder ID
    #       path = "/home/myusername/Documents";    # Which folder to add to Syncthing
    #       devices = [ "device1" "device2" ];      # Which devices to share the folder with
    #     };
    #     "Example" = {
    #       path = "/home/myusername/Example";
    #       devices = [ "device1" ];
    #       ignorePerms = false;  # By default, Syncthing doesn't sync file permissions. This line enables it for this folder.
    #     };
    #   };
    # };
    settings.gui = {
      user = "aviva";
      # yeah, this is checked in
      # no, i don't think it's a problem
      # nix syncthing doesn't seem to want to read from sops
      # so... here we are
      password = "Uc*^8gi4oS&4ZD";
    };
  };

  # Syncthing ports: 8384 for remote access to GUI
  # 22000 TCP and/or UDP for sync traffic
  # 21027/UDP for discovery
  # source: https://docs.syncthing.net/users/firewall.html
  networking.firewall.allowedTCPPorts = [
    # 8384
    22000
  ];
  networking.firewall.allowedUDPPorts = [
    22000
    21027
  ];
}
