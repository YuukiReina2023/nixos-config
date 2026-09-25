{ config, ... }:
{
  imports = [
    ./rofi/default.nix
    ./fcitx5/default.nix              # fcitx5 輸入法框架
    ./window-managers/default.nix     # window managers
    ./waybar/default.nix
    ./gtk/default.nix
    ./wallpapers
    ./foot/default.nix
    ./bash/default.nix
    ./nixvim/default.nix
    ./swappy/default.nix
    ./packages.nix
    ./virt-manager/default.nix
    # features
    ./features/screenshot.nix
    ./starship/default.nix
    ./fastfetch/default.nix
    ./tmux/default.nix
    ./cli/default.nix
    ./discord/default.nix
    ./yazi/default.nix
    ./noctalia/default.nix
    ./tools.nix
    ./obs-studio/default.nix
    ./bottles/default.nix
    ./qq/default.nix
    ./wechat/default.nix
    ./xdg-portal.nix
    ./chrome/default.nix
    ./file-roller/default.nix
    ./fish/default.nix
    ./deploy-files.nix
    ./flake-pkgs.nix
    ./devshell/default.nix
    ./waydroid/default.nix
  ];

  xdg = {
    enable = true;
    userDirs.enable = false;
  };

  home.sessionPath = [ "$HOME/.local/bin" ];
  home.sessionVariables = {
    GOPATH = "${config.xdg.dataHome}/go";
    PYTHON_HISTORY = "${config.xdg.stateHome}/python/history";
    NPM_CONFIG_CACHE = "${config.xdg.cacheHome}/npm";
    NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npm/npmrc";
    WGETRC = "${config.xdg.configHome}/wget/wgetrc";
    LESSHISTFILE = "${config.xdg.stateHome}/less/history";
    CARGO_HOME = "${config.xdg.dataHome}/cargo";
    GNUPGHOME = "${config.xdg.dataHome}/gnupg";

    # fcitx5 輸入法：niri 不支援 text-input-v2（Qt < 6.7 需要），
    # 故 Qt 應用需用 fcitx im module；Qt 6.7+ 優先 wayland 再 fallback 到 fcitx
    QT_IM_MODULE = "fcitx";
    QT_IM_MODULES = "wayland;fcitx";

    # X11 / XWayland 應用走 XIM 協定呼叫 fcitx5；GTK4 / Wayland 原生使用 text-input 協定，
    # 官方強烈建議不要全域設定 GTK_IM_MODULE=fcitx 以免破壞 GTK4 原生輸入法支援。
    XMODIFIERS = "@im=fcitx";
  };

  xdg.configFile."wget/wgetrc".text = ''
    continue = on
  '';

  home.username = "yuukireina2023";
  home.homeDirectory = "/home/yuukireina2023";
  home.stateVersion = "25.11";

}
