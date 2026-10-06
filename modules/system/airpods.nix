{ pkgs, ... }:

let
  airpods-helper = pkgs.callPackage ../../pkgs/airpods-helper.nix { };
in
{
  environment.systemPackages = [
    airpods-helper
  ];

  # 注册 D-Bus 服务
  services.dbus.packages = [ airpods-helper ];

  # 为 airpods-daemon 提供访问蓝牙 L2CAP 原始套接字所需的权限包装器
  security.wrappers.airpods-daemon = {
    owner = "root";
    group = "root";
    capabilities = "cap_net_raw,cap_net_admin+ep";
    source = "${airpods-helper}/bin/airpods-daemon";
  };

  # 用户级后台守护进程：与 BlueZ、MPRIS 播放器及 D-Bus 会话通信
  systemd.user.services.airpods-daemon = {
    description = "Apple AirPods Helper Daemon";
    after = [ "bluetooth.target" ];
    wants = [ "bluetooth.target" ];
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "/run/wrappers/bin/airpods-daemon";
      Restart = "on-failure";
      RestartSec = 5;
    };
  };
}
