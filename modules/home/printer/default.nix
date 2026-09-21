{ config, pkgs, ... }:
{
  # Home Manager: printer / printing-related user packages
  home.packages = with pkgs; [
    epson-escpr
    epson-inkjet-printer-escpr2
    # 保留驱动与用户工具；图形配置与扫描工具已在系统级安装
  ];
}
