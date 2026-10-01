{ ... }:
{
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        source = "NixOS"; # 精致版 NixOS 大雪花 Logo
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
        {
          type = "terminalfont";
          format = "{name} {size}"; # 仅显示主字体与字号，避免 fallback 字体链过长溢出
        }
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
          format = "{name} - {temperature}"; # 紧凑显卡与温度显示，避免详细规格导致溢出
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
