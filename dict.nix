{
  pkgs,
  lib,
  rustbin,
  ...
}:
{
  environment = {
    systemPackages = with pkgs; [
      dict
      rustbin.distsort
    ];
    wordlist.enable = true;
  };
  services.dictd = {
    enable = true;
    DBs = with pkgs.dictdDBs; [
      wiktionary
    ];
  };
}
