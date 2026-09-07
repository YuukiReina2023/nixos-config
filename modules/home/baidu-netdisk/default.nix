{ pkgs, ... }:

{
  home.packages = with pkgs; [
    baidupcs-go
  ];

  # 百度网盘/百度网盘 CLI 在 launcher 或桌面入口中启动时，显式注入 fcitx5
  # 以保证 Wayland / X11 兼容环境下的中文输入正常工作。
  xdg.desktopEntries.baidu-netdisk = {
    name = "Baidu Netdisk";
    exec = "env QT_IM_MODULE=fcitx GTK_IM_MODULE=fcitx XMODIFIERS=@im=fcitx baidupcs-go %U";
    icon = "baidunetdisk";
    comment = "Baidu Netdisk";
    categories = [ "Network" "FileTransfer" ];
    terminal = false;
    type = "Application";
  };
}
