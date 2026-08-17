{ pkgs, config, ... }:

{
  # Docker
  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
  };

  # Virtual Machine (QEMU/KVM)
  # 修改为小写，或者由于下文 extraGroups 已包含，这行也可以直接删掉
  users.groups.libvirtd.members = [ "yuukireina2023" ];

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true; # TPM support
      vhostUserPackages = with pkgs; [ virtiofsd ];
    };
  };

  virtualisation.spiceUSBRedirection.enable = true;

  # UEFI firmware symlink fix
  systemd.tmpfiles.rules = [
    "L+ /var/lib/qemu/firmware - - - - ${pkgs.qemu}/share/qemu/firmware"
  ];

  # 这里改用 lib.mkMerge 或直接将 libvirtd/kvm 加入 users.nix 的 extraGroups
  # 如果保留在此处，必须将属性名改为小写：
  users.users.yuukireina2023 = {
    extraGroups = [
      "libvirtd"
      "kvm"
      "qemu-libvirtd"
    ];
  };

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
