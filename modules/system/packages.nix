{ pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;

  # Enable Java and set JAVA_HOME automatically
  programs.java.enable = true;

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
    rocmPackages.rocm-smi # AMD GPU 監控工具（Radeon PRO W6800）

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
    protonup-qt # Proton 版本管理工具

  ];
}
