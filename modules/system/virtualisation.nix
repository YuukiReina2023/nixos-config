{ pkgs, config, ... }:

{
  # Docker
  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
  };

  # Virtual Machine (QEMU/KVM)
  programs.virt-manager.enable = true;
  programs.dconf.enable = true;

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true; # TPM support
      vhostUserPackages = with pkgs; [ virtiofsd ];
    };
  };

  virtualisation.waydroid.enable = true;
  networking.nftables.enable = true;

  virtualisation.spiceUSBRedirection.enable = true;

  # UEFI firmware symlink fix (使用輕量 qemu_kvm，避免重複下載龐大的多架構全套 qemu)
  systemd.tmpfiles.rules = [
    "L+ /var/lib/qemu/firmware - - - - ${pkgs.qemu_kvm}/share/qemu/firmware"
  ];

  users.users.yuukireina2023 = {
    extraGroups = [
      "libvirtd"
      "kvm"
      "qemu-libvirtd"
    ];
  };

  environment.systemPackages = with pkgs; [
    virt-viewer # SPICE viewer
    virtio-win
    spice-gtk # SPICE GTK client
    dnsmasq # NAT networking
    bridge-utils
    vde2
    iptables
  ];
}