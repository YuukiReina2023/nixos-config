# wallpapers - Desktop wallpaper collection

{ config, ... }:

{
  xdg.configFile."noctalia/wallpapers" = {
    source = ../wallpapers;
    recursive = true;
    force = true;
  };
}
