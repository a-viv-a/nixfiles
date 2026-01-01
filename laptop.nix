{
  pkgs,
  lib,
  config,
  ...
}:
{
  specialisation.igpu-only.configuration = {
    services.xserver.videoDrivers = lib.mkForce [ "amdgpu" ];
    hardware.nvidia.prime.offload.enable = lib.mkForce false;
    hardware.nvidia.prime.offload.enableOffloadCmd = lib.mkForce false;
    boot.blacklistedKernelModules = [ "nvidia" "nvidia_drm" "nvidia_modeset" "nvidia_uvm" ];
    # nvidia card still shows up as card1 even when blacklisted, AMD is card2
    # (can't use by-path symlinks - wlroots parses colons as device separators)
    environment.sessionVariables.WLR_DRM_DEVICES = lib.mkForce "/dev/dri/card2";
  };
  services.auto-cpufreq.enable = true;
  services.auto-cpufreq.settings = {
    battery = {
      governor = "powersave";
      energy_performance_preference = "power";
      turbo = "never";
    };
    charger = {
      governor = "performance";
      energy_performance_preference = "performance";
      turbo = "auto";
    };
  };

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  # nvidia drivers
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.graphics.enable = true;

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = true;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      nvidiaBusId = "PCI:1:0:0";
      amdgpuBusId = "PCI:4:0:0";
    };
  };

  # razer blade lid hibernate bug fix
  boot.kernelParams = [
    "button.lid_init_state=open"
    # samsung t7 ssd: disable UAS (USB Attached SCSI) to prevent stability issues
    "usb-storage.quirks=04e8:4001:u"
  ];

  # allow brightness to be changed without root (both amd and nvidia)
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="amdgpu_bl1", MODE="0666", RUN+="${pkgs.coreutils}/bin/chmod a+w /sys/class/backlight/%k/brightness"
    ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="amdgpu_bl2", MODE="0666", RUN+="${pkgs.coreutils}/bin/chmod a+w /sys/class/backlight/%k/brightness"
    ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="nvidia_0", MODE="0666", RUN+="${pkgs.coreutils}/bin/chmod a+w /sys/class/backlight/%k/brightness"
  '';
}
