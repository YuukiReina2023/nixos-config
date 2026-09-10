{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    wechat
  ];

  # 桌面啟動快捷方式：讓 Electron 應用使用 Wayland text-input/or fcitx5
  xdg.desktopEntries.wechat = {
    name = "WeChat";
    exec = "wechat --ozone-platform-hint=auto --enable-features=WaylandWindowDecorations,UseOzonePlatform --enable-wayland-ime";
    icon = "wechat";
    comment = "WeChat for Linux";
    categories = [ "Network" "InstantMessaging" ];
    terminal = false;
  };
}
