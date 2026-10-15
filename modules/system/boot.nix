{ pkgs, ... }:
{
  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 15;
    # 显式定义 Windows 启动入口
    extraEntries = {
      "windows.conf" = ''
        title Windows 11
        efi /EFI/Microsoft/Boot/bootmgfw.efi
        sort-key 99
      '';
    };
    # 自动从 Windows EFI 分区 (nvme0n1p1, UUID: FA51-B15F) 复制启动文件至 /boot
    extraInstallCommands = ''
      ${pkgs.coreutils}/bin/mkdir -p /boot/EFI
      WIN_ESP_MNT=$(${pkgs.coreutils}/bin/mktemp -d)
      if ${pkgs.util-linux}/bin/mount -t vfat -o ro /dev/disk/by-uuid/FA51-B15F "$WIN_ESP_MNT" 2>/dev/null; then
        if [ -d "$WIN_ESP_MNT/EFI/Microsoft" ]; then
          ${pkgs.coreutils}/bin/cp -r "$WIN_ESP_MNT/EFI/Microsoft" /boot/EFI/
        fi
        ${pkgs.util-linux}/bin/umount "$WIN_ESP_MNT" 2>/dev/null || true
      fi
      ${pkgs.coreutils}/bin/rm -rf "$WIN_ESP_MNT" 2>/dev/null || true

      # 禁用 systemd-boot 自动探测重复生成的 "Windows Boot Manager"，统一使用上述定义的 "Windows 11"
      if [ -f /boot/loader/loader.conf ]; then
        if ${pkgs.gnugrep}/bin/grep -q "auto-windows" /boot/loader/loader.conf; then
          ${pkgs.gnused}/bin/sed -i 's/^auto-windows.*/auto-windows false/' /boot/loader/loader.conf
        else
          echo "auto-windows false" >> /boot/loader/loader.conf
        fi
      fi
    '';
  };

  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelParams = [
    "btusb.enable_autosuspend=0"
  ];

  boot.kernelModules = [
    "ip_tables"
    "iptable_filter"
    "iptable_nat"
    "br_netfilter"
  ];

  boot.kernel.sysctl = {
    "net.core.default_qdisc" = "fq";
    "net.ipv4.tcp_congestion_control" = "bbr";
  };

  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;

  boot.supportedFilesystems = [ "ntfs" ];

  services.fstrim.enable = true;
  zramSwap.enable = true;
}
