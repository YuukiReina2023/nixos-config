{ ... }:
{
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        source = "nixos_old"; # 经典 ASCII 字符点阵大雪花（Neofetch 原版排版）
        type = "builtin";
        padding = {
          top = 0;
          right = 4;
        };
      };
      display = {
        showErrors = false;
      };
      modules = [
        "title"
        "separator"

        # 系统与引导信息
        "os"
        "host"
        "chassis"
        "board"
        "bios"
        "bootmgr"
        "initsystem"
        "kernel"
        "uptime"
        "loadavg"
        "processes"
        "packages"
        "shell"
        "editor"

        # 桌面与图形界面
        "display"
        "de"
        "wm"
        "wmtheme"
        "theme"
        "icons"
        "font"
        "cursor"
        "terminal"
        "terminalfont"
        "terminalsize"

        # 核心硬件（包含温度与传感器监控）
        {
          type = "cpu";
          temp = true;
          showPeCoreCount = true;
        }
        "cpucache"
        {
          type = "gpu";
          temp = true;
          driverSpecific = true;
        }
        "vulkan"
        "opengl"
        "opencl"
        "memory"
        "swap"
        {
          type = "disk";
          showExternal = true;
        }
        "physicaldisk"
        "btrfs"

        # 外设与网络
        "sound"
        "tpm"
        "localip"
        "dns"
        "locale"
        "datetime"

        # 底部分隔与调色盘
        "break"
        "colors"
      ];
    };
  };
}
