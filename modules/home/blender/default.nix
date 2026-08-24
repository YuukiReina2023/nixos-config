{ pkgs, ... }:
{
  # Blender - 3D 建模與渲染（AMD HIP/ROCm GPU 加速）
  home.packages = [ (pkgs.blender.override { rocmSupport = true; }) ];
}