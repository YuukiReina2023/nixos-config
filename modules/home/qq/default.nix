{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    qq
  ];

  # 針對 Niri/Wayland 與 Fcitx5 環境微調 QQ 的桌面啟動快捷方式
  xdg.desktopEntries.qq = {
    name = "QQ";
    # 強制 Electron 讀取 Niri 的 text-input-v3 協議以完美呼叫 fcitx5 輸入法
    exec = "qq --ozone-platform-hint=auto --enable-features=WaylandWindowDecorations,UseOzonePlatform --enable-wayland-ime";
    icon = "qq";
    comment = "Tencent QQ for Linux";
    categories = [ "Network" "InstantMessaging" ];
    terminal = false;
  };
}
