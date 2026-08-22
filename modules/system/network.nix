{ ... }:
{
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.powersave = false;

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
        psk = "Neko1989.6.4";
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
}
