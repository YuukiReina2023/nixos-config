{ pkgs, ... }:
{
  home.packages = [
    pkgs.file-roller
  ];

  xdg.mimeApps.enable = true;
  xdg.mimeApps.defaultApplications = {
    # zip
    "application/zip" = [ "org.gnome.FileRoller.desktop" ];
    "application/x-zip-compressed" = [ "org.gnome.FileRoller.desktop" ];
    # 7z
    "application/x-7z-compressed" = [ "org.gnome.FileRoller.desktop" ];
    # rar
    "application/x-rar" = [ "org.gnome.FileRoller.desktop" ];
    "application/vnd.rar" = [ "org.gnome.FileRoller.desktop" ];
    # tar / gzip / bzip / xz / lzma / lz4 / zstd
    "application/x-tar" = [ "org.gnome.FileRoller.desktop" ];
    "application/gzip" = [ "org.gnome.FileRoller.desktop" ];
    "application/x-bzip" = [ "org.gnome.FileRoller.desktop" ];
    "application/x-bzip2" = [ "org.gnome.FileRoller.desktop" ];
    "application/x-xz" = [ "org.gnome.FileRoller.desktop" ];
    "application/x-compressed-tar" = [ "org.gnome.FileRoller.desktop" ];
    "application/x-bzip-compressed-tar" = [ "org.gnome.FileRoller.desktop" ];
    "application/x-lzma" = [ "org.gnome.FileRoller.desktop" ];
    "application/x-lz4" = [ "org.gnome.FileRoller.desktop" ];
    "application/x-zstd" = [ "org.gnome.FileRoller.desktop" ];
    "application/x-tzst" = [ "org.gnome.FileRoller.desktop" ];
    # 其他归档格式
    "application/x-cpio" = [ "org.gnome.FileRoller.desktop" ];
    "application/x-archive" = [ "org.gnome.FileRoller.desktop" ];
    "application/x-rpm" = [ "org.gnome.FileRoller.desktop" ];
    "application/x-deb" = [ "org.gnome.FileRoller.desktop" ];
    "application/x-iso9660-image" = [ "org.gnome.FileRoller.desktop" ];
    "application/vnd.ms-cab-compressed" = [ "org.gnome.FileRoller.desktop" ];
  };
}