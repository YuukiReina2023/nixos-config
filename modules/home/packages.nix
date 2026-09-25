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

    fastfetch

    gthumb
    mpv
    postman
    spotify
    zathura

    #postgresql
    postgresql_17
    prisma-engines

    # hypr
    hyprlock
    wlr-randr # display management
    cliphist

    kitty

    libreoffice-fresh
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
}
