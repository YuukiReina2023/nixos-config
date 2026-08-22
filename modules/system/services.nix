{ pkgs, config, ... }:
{
  # 1. 禁用 Hyprland，启用系统级 Niri 窗口管理器
  programs.hyprland = {
    enable = false;
    xwayland.enable = true;
  };

  programs.niri.enable = true; # 在系统级启用 Niri

  # 2. 硬件与系统服务配置
  services.upower.enable = true;
  hardware.bluetooth = {
    enable = true;
    settings = {
      General = {
        UserspaceHID = "true";
      };

      LE = {
        MinConnectionInterval = 7; # 7 * 1.25ms = 8.75ms
        MaxConnectionInterval = 9; # 9 * 1.25ms = 11.25ms
        ConnectionLatency = 0;
        SupervisionTimeout = 100;
      };
    };
  };

  services.blueman.enable = true;
  hardware.enableAllFirmware = true;
  services.power-profiles-daemon.enable = true;

  programs.thunar.enable = true;
  services.gvfs.enable = true;
  services.tumbler.enable = true;
  services.openssh.enable = true;

  security.polkit.enable = true;

  # 3. 数据库配置
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_17;

    settings = {
      timezone = "Asia/Shanghai";
      log_timezone = "Asia/Shanghai";
    };

    authentication = pkgs.lib.mkOverride 10 ''
      # TYPE  DATABASE  USER  ADDRESS     METHOD
      local   all       all               peer
      host    all       all   127.0.0.1/32  scram-sha-256
      host    all       all   ::1/128       scram-sha-256
    '';

    ensureDatabases = [
      "mydb"
      "yuukireina2023"
    ];
    ensureUsers = [
      {
        name = "yuukireina2023";
        ensureDBOwnership = true;
      }
    ];
  };
}
