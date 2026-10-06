{ pkgs, ... }:
{
  gtk.gtk4.theme = null;

  gtk = {
    enable = true;
    theme = {
      name = "Colloid-Dark";
      package = pkgs.colloid-gtk-theme;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    cursorTheme = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
      size = 24;
    };
  };

  home.sessionVariables = {
    XDG_ICON_THEME = "Papirus-Dark";
    QT_QPA_PLATFORMTHEME = "gtk3";
    QS_ICON_THEME = "Papirus-Dark";
    XCURSOR_THEME = "Bibata-Modern-Ice";
    XCURSOR_SIZE = "24";
  };

  home.pointerCursor = {
    enable = true;
    name = "Bibata-Modern-Ice";
    package = pkgs.bibata-cursors;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };
}
