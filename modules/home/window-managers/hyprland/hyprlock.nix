{ pkgs, ... }:
{
  programs.hyprlock = {
    enable = true;

    settings = {
      general = {
        disable_loading_bar = false;
        hide_cursor = true;
        grace = 0;
        no_fade_in = false;
        no_fade_out = false;
        immediate_render = true;
      };

      # ── Background (读取 Noctalia 壁纸目录) ─────────────────────────
      background = [
        {
          monitor = "";
          # hyprlock 的 background.path 只接受字面路径，不支持 $(...) 命令替换
          path = "/home/yuukireina2023/.config/noctalia/wallpapers/wallpaper.png";
          blur_passes = 3;
          blur_size = 7;
          brightness = 0.5;
          contrast = 1.0;
          vibrancy = 0.2;
          vibrancy_darkness = 0.1;
        }
      ];

      # ── Clock ─────────────────────────────────────────────────────
      label = [
        {
          monitor = "";
          text = ''cmd[update:1000] echo "$(date +"%H:%M")"'';
          color = "rgba(200, 211, 245, 1.0)"; # text #c8d3f5
          font_size = 96;
          font_family = "JetBrainsMono Nerd Font Bold";
          position = "0, 200";
          halign = "center";
          valign = "center";
          shadow_passes = 3;
          shadow_size = 10;
          shadow_color = "rgba(27, 29, 43, 0.8)";
        }

        # ── Date (修复语言混用，使用规范格式) ───────────────────────
        {
          monitor = "";
          # 如果想用规范中文（例：2026年08月22日 星期六）：
          text = ''cmd[update:60000] echo "$(LC_TIME=zh_CN.UTF-8 date +'%Y年%m月%d日 %A')"'';
          
          # 如果想用规范英文（例：Saturday, 22 Aug 2026），请解除下面这行的注释并替换上一行：
          # text = ''cmd[update:60000] echo "$(LC_TIME=en_US.UTF-8 date +'%A, %d %b %Y')"'';

          color = "rgba(130, 139, 184, 1.0)"; # subtext #828bb8
          font_size = 22;
          font_family = "LXGW WenKai"; # 修改为你的字体（如 LXGW WenKai 或 JetBrainsMono）
          position = "0, 110";
          halign = "center";
          valign = "center";
          shadow_passes = 2;
          shadow_size = 8;
          shadow_color = "rgba(27, 29, 43, 0.8)";
        }

        # ── Greeting ──────────────────────────────────────────────────
        {
          monitor = "";
          text = "Welcome back, Nishan";
          color = "rgba(130, 56, 252, 0.85)"; # purple #c099ff toned
          font_size = 16;
          font_family = "JetBrainsMono Nerd Font";
          position = "0, 60";
          halign = "center";
          valign = "center";
        }

        # ── Caps Lock warning ($CAPS 为 hyprlock 原生变量，启用时显示 "Caps Lock") ──
        {
          monitor = "";
          text = "$CAPS"; # 只有 CapsLock 启用时才会动态显示提示
          color = "rgba(255, 117, 127, 1.0)"; # red #ff757f
          font_size = 14;
          font_family = "JetBrainsMono Nerd Font Bold";
          position = "0, -180";
          halign = "center";
          valign = "center";
        }
      ];

      # ── Avatar (修复了路径) ─────────────────────────────────────────
      image = [
        {
          monitor = "";
          path = "/home/yuukireina2023/.face"; # 使用完整绝对路径
          size = 100;
          rounding = -1; # fully circular
          border_size = 3;
          border_color = "rgba(130, 170, 255, 0.8)"; # blue #82aaff
          position = "0, -30";
          halign = "center";
          valign = "center";
          shadow_passes = 2;
          shadow_size = 10;
          shadow_color = "rgba(27, 29, 43, 0.6)";
        }
      ];

      # ── Password input ────────────────────────────────────────────
      input-field = [
        {
          monitor = "";
          size = "280, 52";
          position = "0, -140";
          halign = "center";
          valign = "center";

          outline_thickness = 2;
          dots_size = 0.25;
          dots_spacing = 0.2;
          dots_center = true;
          dots_rounding = -1;

          outer_color = "rgba(47, 51, 77, 0.9)"; # surface0 #2f334d
          inner_color = "rgba(34, 36, 54, 0.95)"; # bg #222436
          font_color = "rgba(200, 211, 245, 1.0)"; # text #c8d3f5
          fade_on_empty = true;
          fade_timeout = 1000;

          placeholder_text = ''<span foreground="##828bb8"> Password...</span>'';
          hide_input = false;
          rounding = 12;

          check_color = "rgba(195, 232, 141, 1.0)"; # green #c3e88d
          fail_color = "rgba(255, 117, 127, 1.0)"; # red #ff757f
          fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
          fail_transition = 300;

          capslock_color = "rgba(255, 199, 119, 1.0)"; # yellow #ffc777
          numlock_color = "rgba(130, 170, 255, 1.0)"; # blue #82aaff
          bothlock_color = "rgba(255, 117, 127, 1.0)"; # red

          shadow_passes = 3;
          shadow_size = 12;
          shadow_color = "rgba(27, 29, 43, 0.8)";
        }
      ];
    };
  };
}
