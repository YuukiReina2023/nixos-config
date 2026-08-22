{ pkgs, ... }:
{
  boot.loader.systemd-boot = {
    enable = true;
    # 显式定义 Windows 启动入口
    extraEntries = {
      "windows.conf" = ''
        title Windows 11
        efi /EFI/Microsoft/Boot/bootmgfw.efi
      '';
    };
  };

  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelParams = [
    "btusb.enable_autosuspend=0"
  ];

  boot.kernelModules = [
    "kvm_intel"
  ];

  boot.kernel.sysctl = {
    "net.core.default_qdisc" = "fq";
    "net.ipv4.tcp_congestion_control" = "bbr";
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.supportedFilesystems = [ "ntfs" ];

  boot.extraModprobeConfig = ''
    options rtw89_pci disable_clkreq=y disable_aspm_l1=y disable_aspm_l1ss=y
  '';
}
