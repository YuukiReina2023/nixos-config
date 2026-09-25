{ ... }:
{
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.powersave = false;

  # Wi-Fi 連線由 NetworkManager 本地安全管理（使用 nmcli 或桌面 nm-applet 連線），
  # 避免將 Wi-Fi 密碼明文硬編碼在 Git 追蹤的配置中。

  networking.firewall.trustedInterfaces = [ "virbr0" ]; # virtual machine
}
