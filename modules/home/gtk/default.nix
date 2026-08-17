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
      name = "volantes_cursors";
      package = pkgs.volantes-cursors;
      size = 32;
    };
  };

  home.sessionVariables = {
    XDG_ICON_THEME = "Papirus-Dark";
    QT_QPA_PLATFORMTHEME = "gtk3";
    QS_ICON_THEME = "Papirus-Dark";
  };

  home.pointerCursor = {
    name = "volantes_cursors";
    package = pkgs.volantes-cursors;
    size = 32;
    gtk.enable = true;
    x11.enable = true;
  };
}
