{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    tencent-qq
  ];

  # 針對 Niri/Wayland 環境微調 QQ 的桌面啟動快捷方式
  xdg.desktopEntries.qq = {
    name = "QQ";
    exec = "qq --ozone-platform-hint=auto --enable-features=WaylandWindowDecorations,UseOzonePlatform --enable-wayland-ime";
    icon = "qq";
    comment = "Tencent QQ for Linux";
    categories = [ "Network" "InstantMessaging" ];
    # 確保 Niri 視窗管理器的 Rofi 或 Noctalia 啟動器載入此覆寫設定
    terminal = false;
  };
}
