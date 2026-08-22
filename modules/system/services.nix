{ pkgs, config, ... }:
{
  # 1. 禁用 Hyprland，啟用系統級 Niri 視窗管理器
  programs.hyprland = {
    enable = false;
    xwayland.enable = true;
  };

  programs.niri.enable = true; # 在系統級啟用 Niri

  # 2. 顯示管理器配置：改用 Greetd 搭配 tuigreet
  services.displayManager.sddm.enable = false;

  services.greetd = {
    enable = true;
    vt = 1; # 修正：強制指定卡位 tty1，阻止 agetty (命令行登入) 搶先啟動
    settings = {
      default_session = {
        # 修正：加上 --remember-session 並確保 command 格式完整
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-session --cmd niri";
        user = "greeter";
      };
    };
  };

  # 確保 systemd 預設目標直接進入圖形化 target
  systemd.defaultUnit = "graphical.target";

  # 啟用 GNOME Keyring 供 greetd 登入時自動解鎖秘鑰環
  security.pam.services.greetd.enableGnomeKeyring = true;

  # 3. 硬體與系統服務配置
  services.upower.enable = true;
  hardware.bluetooth = {
    enable = true;
    settings = {
      General = {
        UserspaceHID = "true";
      };
      LE = {
        MinConnectionInterval = 7;
        MaxConnectionInterval = 9;
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

  # 4. 資料庫配置
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
