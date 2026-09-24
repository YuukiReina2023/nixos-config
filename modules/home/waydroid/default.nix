{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellScriptBin "waydroid-fcitx" ''
      export GTK_IM_MODULE=fcitx
      export QT_IM_MODULE=fcitx
      export QT_IM_MODULES="wayland;fcitx"
      export XMODIFIERS="@im=fcitx"

      exec ${pkgs.waydroid}/bin/waydroid "$@"
    '')
  ];

  xdg.configFile."waydroid/fcitx5.conf".text = ''
    # Environment variables used by the waydroid-fcitx launcher.
    GTK_IM_MODULE=fcitx
    QT_IM_MODULE=fcitx
    QT_IM_MODULES=wayland;fcitx
    XMODIFIERS=@im=fcitx
  '';
}