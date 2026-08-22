{ pkgs, ... }:
{
  # 挂载 Windows 数据分区 (nvme0n1p2)
  fileSystems."/run/media/yuukireina2023/lw" = {
    device = "/dev/nvme0n1p2";
    fsType = "ntfs3"; # 使用 kernel 内置的高性能 ntfs3 驱动
    options = [
      "rw"
      "nofail"
      "uid=1000"         # 1000 通常是你的主用户 (yuukireina2023) 的 UID
      "gid=100"          # 100 是 users 组的 GID
      "fmask=0022"       # 设置文件权限 (允许读写)
      "dmask=0022"       # 设置文件夹权限
      "windows_names"    # 防止创建 Windows 不支持的特殊字符文件名
    ];
  };

  # 挂载 Windows EFI 分区 (用于 systemd-boot 跨盘识别 Windows 引导)
  fileSystems."/boot-win" = {
    device = "/dev/disk/by-partuuid/9783550e-5107-4e02-ac1a-a3f17d727617";
    fsType = "vfat";
    options = [
      "ro"
      "nofail"
    ];
  };
}
