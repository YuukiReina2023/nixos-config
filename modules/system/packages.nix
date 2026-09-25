{ pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;

  # Enable Java and set JAVA_HOME automatically
  programs.java.enable = true;

  # 遊戲平台與效能最佳化（系統層級提供 32 位元驅動、FHS 隔離、udev 規則與提權調度）
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable = true;
  };

  programs.gamemode.enable = true;

  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  # 網路封包分析（為 dumpcap 配置 Capabilities，使在 wireshark 群組內的非 root 使用者可直接擷取封包）
  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };

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
