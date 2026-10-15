{ pkgs, ... }:
{
  # Enable Java and set JAVA_HOME automatically
  programs.java.enable = true;

  # Android 调试桥 (ADB) 与 USB udev 规则支持（真机调试必须）
  programs.adb.enable = true;

  environment.systemPackages = with pkgs; [
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
    rocmPackages.rocm-smi

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
