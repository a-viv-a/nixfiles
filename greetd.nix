{
  pkgs,
  lib,
  ...
}:
{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        # needs to be a single line to work right!
        command =
          with pkgs;
          lib.concatStringsSep " " [
            "${lib.getExe tuigreet}"
            "--time"
            "--asterisks"
            "--user-menu"
            "--greeting \"Gam Zeh Ya'avor\""
            "--cmd river"
          ];
        # need to be the greeter user to work!
        user = "greeter";
      };
      initial_session = {
        command = lib.getExe pkgs.river-classic;
        user = "aviva";
      };
    };
  };

  environment.etc."greetd/environments".text = ''
    	river
    	fish
    	bash
  '';
}
