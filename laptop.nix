{ pkgs, lib, ... }: {
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

  # allow brightness to be changed without root
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="amdgpu_bl2", MODE="0666", RUN+="${pkgs.coreutils}/bin/chmod a+w /sys/class/backlight/%k/brightness"
  '';
}
