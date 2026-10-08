{ pkgs, ... }:
{
  home.packages = with pkgs; [
    motrix # 开源全功能桌面下载器（基于 aria2 内核，支持 HTTP/HTTPS、FTP、BitTorrent、Magnet、Metalink 等）
    aria2  # 多协议命令行下载工具（支持 HTTP/HTTPS、FTP、SFTP、BitTorrent、Metalink）
  ];

  # 关联下载相关的 MIME 类型与 URL Scheme，默认由 Motrix 接管
  xdg.mimeApps.enable = true;
  xdg.mimeApps.defaultApplications = {
    "x-scheme-handler/magnet" = [ "motrix.desktop" ];
    "application/x-bittorrent" = [ "motrix.desktop" ];
    "x-scheme-handler/thunder" = [ "motrix.desktop" ];
    "x-scheme-handler/mo" = [ "motrix.desktop" ];
    "x-scheme-handler/motrix" = [ "motrix.desktop" ];
  };
}
