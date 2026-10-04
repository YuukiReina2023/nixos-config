{ config, pkgs, ... }:
#  ███╗   ██╗ ██████╗  ██████╗████████╗ █████╗ ██╗     ██╗ █████╗
#  ████╗  ██║██╔═══██╗██╔════╝╚══██╔══╝██╔══██╗██║     ██║██╔══██╗
#  ██╔██╗ ██║██║   ██║██║        ██║   ███████║██║     ██║███████║
#  ██║╚██╗██║██║   ██║██║        ██║   ██╔══██║██║     ██║██╔══██║
#  ██║ ╚████║╚██████╔╝╚██████╗   ██║   ██║  ██║███████╗██║██║  ██║
#  ╚═╝  ╚═══╝ ╚═════╝  ╚═════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝╚═╝  ╚═╝
#            noctalia v5 · glass rice · wallpaper-driven colors
#            https://docs.noctalia.dev/v5
{
  programs.noctalia = {
    enable = true;
    checkConfig = true;

    # 按照官方模板 config.toml 完整保留全部注释与未使用配置项
    settings = builtins.replaceStrings
      [ "@NIXOS_ICON@" ]
      [ "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg" ]
      (builtins.readFile ./config.toml);
  };

  xdg.configFile."noctalia/wallpapers" = {
    source = ../wallpapers;
    recursive = true;
    force = true;
  };
}
