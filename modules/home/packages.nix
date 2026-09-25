{ pkgs, ... }:
{
  home.packages = with pkgs; [
    awww
    papirus-icon-theme
    adw-gtk3
    waypaper

    pavucontrol
    networkmanagerapplet
    nwg-drawer
    nwg-menu

    lf

    gthumb
    postman
    spotify
    zathura

    # Apps consolidated from single-file modules
    (blender.override { rocmSupport = true; })
    hmcl
    obsidian
    netease-cloud-music-gtk
    telegram-desktop

    #postgresql
    postgresql_17
    prisma-engines

    # hypr
    hyprlock
    wlr-randr # display management
    cliphist

    kitty

    libreoffice-stable
    vscode-fhs

    # Screenshot tools
    grim
    slurp
    swappy
    grimblast
    imagemagick
    libnotify

    openssl
  ];

  programs.claude-code.enable = true;
}
