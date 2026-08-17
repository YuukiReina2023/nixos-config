{ ... }:
{
  # Auto mount
  fileSystems."/run/media/yuukireina2023/lw" = {
    device = "/dev/disk/by-label/lw";
    fsType = "ext4";
    options = [
      "defaults"
      "nofail"
    ];
  };
}
