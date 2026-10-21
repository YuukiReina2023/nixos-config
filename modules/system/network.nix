{ pkgs, ... }:
{
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.powersave = false;

  # 禁用以太网 Wake-on-LAN，防止局域网 ARP 与广播包唤醒电脑
  networking.networkmanager.settings = {
    connection = {
      "ethernet.wake-on-lan" = "ignore";
    };
  };
  networking.firewall.trustedInterfaces = [ "virbr0" ]; # virtual machine
  # 放行 WS-Discovery 协议端口 (UDP 3702)，供 WSD 扫描仪局域网自动发现 (AirScan / WSD)
  networking.firewall.allowedUDPPorts = [ 3702 ];

  # Clash Verge 配置 (启用 TUN 模式与服务模式所需的系统权限与防火墙配置)
  programs.clash-verge = {
    enable = true;
    package = pkgs.clash-verge-rev;
    tunMode = true;
    serviceMode = true;
    group = "yuukireina2023";
  };
}
