{ config, ... }:
{
  imports = [
    ./rofi/default.nix
    ./fcitx5/default.nix  # fcitx5 輸入法框架
    ./window-managers/default.nix # window managers
    ./waybar/default.nix
    ./gtk/default.nix
    ./wallpapers
    ./foot/default.nix
    ./bash/default.nix
    ./nixvim/default.nix
    ./swappy/default.nix
    ./packages.nix
    ./virt-manager/default.nix
    ./obsidian/default.nix
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
    ./cc/default.nix
    ./obs-studio/default.nix
    ./telegram/default.nix

    ./xdg-portal.nix
    ./brave/default.nix
    ./chrome/default.nix
    ./fish/default.nix
    ./deploy-files.nix
    ./flake-pkgs.nix
    ./devshell/default.nix
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
  };

  xdg.configFile."wget/wgetrc".text = ''
    continue = on
  '';

  home.username = "yuukireina2023";
  home.homeDirectory = "/home/yuukireina2023";
  home.stateVersion = "25.11";

}
