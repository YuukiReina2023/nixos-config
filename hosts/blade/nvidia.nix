{ config, lib, pkgs, ... }:
{
  # NVIDIA GeForce RTX 3070 Mobile + Intel UHD Graphics 630 (Optimus PRIME 混合渲染)
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver
      libva-vdpau-driver
      libvdpau-va-gl
      nvidia-vaapi-driver
    ];
  };

  # Intel 硬件加速视频解码环境变量
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
  };

  hardware.nvidia = {
    modesetting.enable = true;

    # Ampere 架构移动端动态电源管理（极低待机功耗，无需重启自动休眠独显）
    powerManagement = {
      enable = true;
      finegrained = true;
    };

    # 使用专有稳定版驱动（移动端 Turing/Ampere 细粒度电源管理支持最完善）
    open = false;
    nvidiaSettings = false;

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true; # 提供 nvidia-offload 包装命令
      };
      # Intel UHD Graphics 630 (00:02.0)
      intelBusId = "PCI:0:2:0";
      # NVIDIA GeForce RTX 3070 Mobile (01:00.0)
      nvidiaBusId = "PCI:1:0:0";
    };
  };
}
