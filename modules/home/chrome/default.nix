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

  home.sessionVariables.BROWSER = "google-chrome-stable";
}
