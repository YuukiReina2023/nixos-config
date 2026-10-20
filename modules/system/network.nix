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


  # 强制 WPA2-PSK 连接（绕过 brcmfmac 固件无法处理 WPA2/WPA3 混合模式的 SAE 协商问题）
  networking.networkmanager.ensureProfiles.profiles = {
    "NekoNetWork" = {
      connection = {
        id = "NekoNetWork";
        type = "wifi";
        autoconnect = "true";
        uuid = "5ab4832f-4966-41c5-a60a-bbdd5028a174";
      };
      wifi = {
        ssid = "NekoNetWork";
      };
      wifi-security = {
        key-mgmt = "wpa-psk";
        # 移除 Nix store 全局可读的明文密码，改由 NetworkManager 本地安全存储（连接时提示或通过 nmcli 写入）
        psk-flags = 1;
      };
      ipv4 = {
        method = "auto";
      };
      ipv6 = {
        method = "auto";
      };
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
  };
}
