{ pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    strawberry
    chromaprint
    (beets.override {
      pluginOverrides = {
        chroma.enable = true;
        fetchart.enable = true;
        embedart.enable = true;
        replaygain.enable = true;
        lastgenre.enable = true;
        ftintitle.enable = true;
      };
    })
    (ffmpeg.override {
      # we want libfdk-aac for good aac encoding
      withFdkAac = true;
      withUnfree = true;
    })
    # we use a rockboxed ipod
    rockbox-utility
  ];

  xdg.configFile."beets/config.yaml".source = ./beets/config.yaml;
}
