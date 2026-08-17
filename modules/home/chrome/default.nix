{ pkgs, ... }:
{
  home.packages = [
    pkgs.google-chrome
  ];

  xdg.mimeApps.enable = true;
  xdg.mimeApps.defaultApplications = {
    "text/html" = [ "google-chrome.desktop" ];
    "text/xml" = [ "google-chrome.desktop" ];
    "application/xhtml+xml" = [ "google-chrome.desktop" ];
    "x-scheme-handler/http" = [ "google-chrome.desktop" ];
    "x-scheme-handler/https" = [ "google-chrome.desktop" ];
    "x-scheme-handler/ftp" = [ "google-chrome.desktop" ];
  };

  # 覆蓋 Chrome desktop entry：以 Wayland 模式啟動並啟用 IME（text-input-v3），
  # 讓從 launcher 啟動時也能正常使用 fcitx5 輸入法
  xdg.desktopEntries."google-chrome" = {
    name = "Google Chrome";
    exec = "google-chrome-stable --ozone-platform=wayland --enable-wayland-ime %U";
    icon = "google-chrome";
    terminal = false;
    type = "Application";
    categories = [ "Network" "WebBrowser" ];
    mimeType = [
      "text/html"
      "text/xml"
      "application/xhtml+xml"
      "x-scheme-handler/http"
      "x-scheme-handler/https"
      "x-scheme-handler/ftp"
    ];
  };

  home.sessionVariables.BROWSER = "google-chrome-stable";
}
