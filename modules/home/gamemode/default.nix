{ pkgs, ... }:
{
  # gamemode - 遊戲模式最佳化（CPU 調度與效能提升）
  home.packages = [ pkgs.gamemode ];
}