{ pkgs, ... }:
{
  # Enable Java and set JAVA_HOME automatically
  programs.java.enable = true;

  environment.systemPackages = with pkgs; [
    # Android tools (adb, fastboot等，systemd 258+ 自动处理 uaccess 规则)
    android-tools

    # Core utils
    wget
    git
    vim
    curl
    unzip
    zip
    btop
    python3
    ffmpeg
    pciutils

    docker-compose

    wl-clipboard
    brightnessctl
    playerctl
    xdg-utils
    tree
    ntfs3g
    hyprpolkitagent

    visidata

    # 遊戲轉譯層
    protonup-qt # Proton 版本管理工具

  ];
}
