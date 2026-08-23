{ pkgs, ... }:
{
  # Steam - 遊戲平台（自動處理 32 位元支援與遊戲模式）
  home.packages = [ pkgs.steam ];
}