{ pkgs, config, lib, ... }:
let
  wallpaperSymlink = "${config.xdg.cacheHome}/current_wallpaper.png";
  defaultWallpaper = "${config.xdg.configHome}/noctalia/wallpapers/wallpapers14.png";
  settingsFile = "${config.xdg.stateHome}/noctalia/settings.toml";

  syncWallpaperScript = pkgs.writeShellScript "sync-hyprlock-wallpaper" ''
    set -euo pipefail
    TARGET=""

    # 1. 若 Noctalia 正在運行，優先通過 IPC 獲取當前桌布
    if command -v noctalia >/dev/null 2>&1; then
      TARGET="$(noctalia msg wallpaper-get 2>/dev/null || true)"
    fi

    # 2. 若 IPC 未獲取到（如剛開機啟動階段），直接解析 settings.toml 持久化配置
    if [ -z "$TARGET" ] || [ ! -f "$TARGET" ]; then
      if [ -f "${settingsFile}" ]; then
        TARGET="$(sed -n '/\[wallpaper\.default\]/,/\[/p' "${settingsFile}" | grep -E '^path\s*=' | head -n1 | sed -E 's/^path\s*=\s*"([^"]+)".*/\1/' || true)"
        if [ -z "$TARGET" ] || [ ! -f "$TARGET" ]; then
          TARGET="$(sed -n '/\[wallpaper\.last\]/,/\[/p' "${settingsFile}" | grep -E '^path\s*=' | head -n1 | sed -E 's/^path\s*=\s*"([^"]+)".*/\1/' || true)"
        fi
      fi
    fi

    # 3. 兜底回退預設桌布
    if [ -z "$TARGET" ] || [ ! -f "$TARGET" ]; then
      TARGET="${defaultWallpaper}"
    fi

    # 4. 原子更新符號連結
    if [ -f "$TARGET" ]; then
      mkdir -p "$(dirname "${wallpaperSymlink}")"
      ln -sf "$TARGET" "${wallpaperSymlink}.tmp"
      mv -f "${wallpaperSymlink}.tmp" "${wallpaperSymlink}"
    fi
  '';

  hyprlockWrapped = pkgs.writeShellScriptBin "hyprlock" ''
    ${syncWallpaperScript} || true
    exec ${pkgs.hyprlock}/bin/hyprlock "$@"
  '';
in
{
  # 監聽 Noctalia 設定檔變更（在桌面自選桌布時即時同步）
  systemd.user.paths.sync-hyprlock-wallpaper = {
    Unit.Description = "Watch Noctalia settings for wallpaper changes";
    Path = {
      PathModified = "%h/.local/state/noctalia/settings.toml";
      Unit = "sync-hyprlock-wallpaper.service";
    };
    Install.WantedBy = [ "default.target" ];
  };

  systemd.user.services.sync-hyprlock-wallpaper = {
    Unit.Description = "Sync Noctalia desktop wallpaper to hyprlock";
    Service = {
      Type = "oneshot";
      ExecStart = "${syncWallpaperScript}";
    };
  };

  # 部署時初始化桌布連結
  home.activation.syncHyprlockWallpaper = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${syncWallpaperScript} || true
  '';

  programs.hyprlock = {
    enable = true;
    package = hyprlockWrapped;

    settings = {
      general = {
        disable_loading_bar = false;
        hide_cursor = true;
        grace = 0;
        no_fade_in = false;
        no_fade_out = false;
        immediate_render = true;
      };

      # ── Background (動態同步桌面自選桌布) ─────────────────────────
      background = [
        {
          monitor = "";
          path = wallpaperSymlink;
          blur_passes = 2;
          blur_size = 5;
          brightness = 0.75;
          contrast = 0.95;
          vibrancy = 0.25;
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

        # ── Caps Lock warning (hyprlock 0.9.6 不支持 $CAPS 变量，改用 sysfs LED 检测) ──
        {
          monitor = "";
          # 通过 sysfs 轮询 Caps Lock LED 状态，启用时显示 "Caps Lock"
          text = ''cmd[update:1000] grep -q 1 /sys/class/leds/*capslock*/brightness 2>/dev/null && echo "Caps Lock"'';
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

          outer_color = "rgba(130, 170, 255, 0.45)"; # 半透明強調邊框 #82aaff
          inner_color = "rgba(34, 36, 54, 0.45)";    # 45% 透光毛玻璃底色 #222436
          font_color = "rgba(200, 211, 245, 1.0)";   # text #c8d3f5
          fade_on_empty = false;
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

          shadow_passes = 2;
          shadow_size = 10;
          shadow_color = "rgba(27, 29, 43, 0.5)";
        }
      ];
    };
  };
}
