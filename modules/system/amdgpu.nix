{ ... }:
{
  # AMD Radeon PRO W6800 (RDNA2) — Dell Precision 7820 Tower
  services.xserver.videoDrivers = [ "amdgpu" ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
}