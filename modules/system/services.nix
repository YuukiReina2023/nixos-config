{ pkgs, config, ... }:
{
  # 1. 禁用 Hyprland，啟用系統級 Niri 視窗管理器
  programs.hyprland = {
    enable = false;
    xwayland.enable = true;
  };

  programs.niri.enable = true; # 在系統級啟用 Niri

  # 2. 顯示管理器配置：啟用自动登录以消除双重登录
  services.displayManager.sddm.enable = false;

  services.greetd = {
    enable = true;
    settings = {
      # 开机首次启动时直接自动登录指定用户并启动 niri，跳过 tuigreet
      initial_session = {
        command = "niri";
        user = "yuukireina2023";
      };
      # 手动注销或退出会话后回退到 tuigreet 登录界面
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-session --cmd niri";
        user = "greeter";
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
  # 睡眠防秒醒 udev 规则：
  # - 禁用 2.4G 无线接收器和蓝牙模块的 USB 唤醒，防止鼠标微小晃动、传感器底噪或蓝牙信号波动唤醒电脑
  # - 禁用有线网卡 enp0s31f6 的设备唤醒属性
  services.udev.extraRules = ''
    ATTRS{idVendor}=="04b8", ATTRS{idProduct}=="11b6", MODE="0664", GROUP="lp", ENV{libsane_matched}="yes", TAG+="systemd", ENV{SYSTEMD_WANTS}+="ipp-usb.service"
    ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="3554", ATTRS{idProduct}=="fa09", ATTR{power/wakeup}="disabled"
    ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="05ac", ATTRS{idProduct}=="8290", ATTR{power/wakeup}="disabled"
    ACTION=="add", SUBSYSTEM=="net", NAME=="enp0s31f6", ATTR{device/power/wakeup}="disabled"
  '';

  # 7. 解决睡眠秒醒问题：
  # 禁用 XHCI 与 GBE1 的 ACPI 误唤醒（Dell 工作站/Intel C620 芯片组经典问题，防止睡眠秒醒；机箱电源键 PWRB 仍可正常唤醒）
  systemd.services.disable-acpi-wakeup = {
    description = "Disable spurious ACPI wakeup triggers (XHCI, GBE1)";
    wantedBy = [ "multi-user.target" "post-resume.target" ];
    after = [ "multi-user.target" "post-resume.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "disable-acpi-wakeup" ''
        for dev in XHCI GBE1; do
          if grep -qE "^$dev\s+.*\*enabled" /proc/acpi/wakeup; then
            echo "$dev" > /proc/acpi/wakeup
          fi
        done
      '';
    };
  };


  # 安装打印与扫描开源图形工具
  environment.systemPackages = with pkgs; [
    system-config-printer
    simple-scan # 开源文档扫描工具 (Document Scanner)
  ];
  # Ensure Cachix substituters and trusted keys are available to the Nix daemon
  # (use nix.extraOptions to write to /etc/nix/nix.conf so the daemon trusts the caches)
  # Cachix keys are managed via the dedicated cachix.nix module imported in
  # modules/system/default.nix. Do not set nix.extraOptions here to avoid
  # conflicting writes to /etc/nix/nix.conf.

}
