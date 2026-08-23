{ pkgs, ... }:
{
  # Bottles - 基於 Wine 的 Windows 應用程式管理工具
  home.packages = [ pkgs.bottles ];
}