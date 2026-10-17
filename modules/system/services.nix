{ pkgs, config, ... }:
{
  # 1. 啟用系統級 Niri 視窗管理器
  programs.niri.enable = true;

  services.displayManager.noctalia-greeter = {
    enable = true;
    passwordless-sync-users = [ "yuukireina2023" ]; # 允许你的用户同步壁纸和配色到 Greeter
    settings = {
      session.default = "niri";
      appearance = {
        scheme = "Synced"; # 自动读取桌面壁纸和配色
      };
    };
  };

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
      timezone = "America/New_York";
      log_timezone = "America/New_York";
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

  # 5. 打印服務 (CUPS) 與 Epson 驱动（仅本地，关闭 Web UI 并移除网页快捷方式）
  services.printing = {
    enable = true;
    package = pkgs.symlinkJoin {
      name = "cups";
      paths = [ pkgs.cups.out ];
      postBuild = ''
        rm -f $out/share/applications/cups.desktop
      '';
    };
    webInterface = false; # 禁用 CUPS Web UI
    drivers = with pkgs; [
      epson-escpr
      epson-escpr2
      foomatic-db-ppds
    ];
    openFirewall = false; # 关闭防火墙打印端口暴露，只保留本地访问
    startWhenNeeded = true;
  };

  # 6. 扫描仪服务 (SANE) 与开源驱动方案 (eSCL / AirScan / WSD)
  # Epson WF-C5890 现代多功能一体机支持标准免驱 eSCL (AirScan) 与 WSD 协议。
  # 使用 sane-airscan 提供纯开源实现，无需安装闭源 epsonscan2 驱动与专有插件。
  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.sane-airscan ];
    openFirewall = true;
  };

  # 启用 Avahi (mDNS/DNS-SD)，供 SANE AirScan 自动发现局域网内的 Epson 扫描仪
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # 启用 ipp-usb：若通过 USB 直连，将一体机模拟为本地 eSCL/IPP 免驱扫描仪
  services.ipp-usb.enable = true;

  # Epson WF-C5890 USB 专属 udev 规则：确保设备节点分配至 lp/scanner 组，并唤起 ipp-usb 服务
  services.udev.extraRules = ''
    ATTRS{idVendor}=="04b8", ATTRS{idProduct}=="11b6", MODE="0664", GROUP="lp", ENV{libsane_matched}="yes", TAG+="systemd", ENV{SYSTEMD_WANTS}+="ipp-usb.service"
  '';


  # 安装打印与扫描开源图形工具
  environment.systemPackages = with pkgs; [
    system-config-printer
    simple-scan # 开源文档扫描工具 (Document Scanner)
  ];
  # Cachix 与各镜像源二进制缓存（substituters 及 trusted-public-keys）统一由 modules/system/nix.nix 集中管理。

  systemd.oomd.enable = true;
}
