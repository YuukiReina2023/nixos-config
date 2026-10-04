{ pkgs, ... }:
{
  # 1. 深度美化 fastfetch 作为 hyfetch 的现代化高性能渲染后端
  programs.fastfetch = {
    enable = true;
    settings = {
      display = {
        separator = "  ";
        color = {
          keys = "cyan";
          title = "magenta";
        };
        key = {
          width = 14;
        };
      };
      modules = [
        {
          type = "title";
          format = "{user-name-colored} @ {host-name-colored}";
        }
        {
          type = "separator";
          string = "─";
        }
        {
          type = "os";
          key = "  OS";
        }
        {
          type = "kernel";
          key = "󰒋  Kernel";
        }
        {
          type = "uptime";
          key = "󱘖  Uptime";
        }
        {
          type = "packages";
          key = "󰏖  Packages";
        }
        {
          type = "shell";
          key = "󰞷  Shell";
        }
        {
          type = "wm";
          key = "󱂬  WM";
        }
        {
          type = "theme";
          key = "󰉼  Theme";
        }
        {
          type = "icons";
          key = "󰀻  Icons";
        }
        {
          type = "cpu";
          key = "  CPU";
          temp = true;
          format = "{name} ({cores-physical}C/{cores-logical}T) - {temperature}";
        }
        {
          type = "gpu";
          key = "󰢮  GPU";
          temp = true;
          format = "{name} - {temperature}";
        }
        {
          type = "memory";
          key = "󰍛  Memory";
          format = "{used} / {total} ({percentage})";
        }
        {
          type = "disk";
          key = "󰋊  Disk";
          folders = "/nix";
        }
        {
          type = "localip";
          key = "󰩟  IP";
          showIpv4 = true;
          showIpv6 = false;
        }
        "break"
        {
          type = "colors";
          symbol = "circle";
        }
      ];
    };
  };

  # 2. Hyfetch 主配置：启用 fastfetch 高性能后端与 Transgender 专属 RGB 渐变配色
  programs.hyfetch = {
    enable = true;
    settings = {
      preset = "transgender";
      mode = "rgb";
      backend = "fastfetch";
      color_align = {
        mode = "horizontal";
      };
      distro = "nixos_old";
      pride_month_disable = false;
    };
  };

  # 确保 fastfetch 命令行工具在系统 PATH 可用
  home.packages = with pkgs; [
    fastfetch
  ];
}
