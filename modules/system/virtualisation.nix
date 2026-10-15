{ pkgs, config, ... }:

{
  # Docker
  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
  };

  # Virtual Machine (QEMU/KVM)
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = false;
      swtpm.enable = true; # TPM support
      vhostUserPackages = with pkgs; [ virtiofsd ];
    };
  };

  virtualisation.waydroid.enable = true;
  networking.nftables.enable = true;

  virtualisation.spiceUSBRedirection.enable = true;

  # UEFI firmware symlink fix
  systemd.tmpfiles.rules = [
    "L+ /var/lib/qemu/firmware - - - - ${pkgs.qemu}/share/qemu/firmware"
  ];

  environment.systemPackages = with pkgs; [
    virt-manager
    virt-viewer # SPICE viewer
    virtio-win
    spice-gtk # SPICE GTK client
    dnsmasq # NAT networking
    bridge-utils
    vde2
    iptables
  ];
}