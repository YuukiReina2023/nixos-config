{ pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;

  # Enable Java and set JAVA_HOME automatically
  programs.java.enable = true;

  # Steam 遊戲平台（自動處理 32 位元支援與遊戲模式）
  programs.steam.enable = true;
  programs.gamemode.enable = true;

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

    docker-compose

    wl-clipboard
    brightnessctl
    playerctl
    xdg-utils
    tree
    ntfs3g
    hyprpolkitagent

    visidata

    jdk21

    # 遊戲轉譯層
    gamescope # Wayland 遊戲合成器（Steam 遊戲全螢幕執行）
    wineWowPackages.stable # Wine（32+64 位元）
    winetricks # Wine 設定工具
    protonup-qt # Proton 版本管理工具
    crossover # CodeWeavers CrossOver（商業版 Wine）

  ];
}
