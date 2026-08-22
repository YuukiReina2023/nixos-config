{ config, pkgs, ... }:
#  ███╗   ██╗ ██████╗  ██████╗████████╗ █████╗ ██╗     ██╗ █████╗
#  ████╗  ██║██╔═══██╗██╔════╝╚══██╔══╝██╔══██╗██║     ██║██╔══██╗
#  ██╔██╗ ██║██║   ██║██║        ██║   ███████║██║     ██║███████║
#  ██║╚██╗██║██║   ██║██║        ██║   ██╔══██║██║     ██║██╔══██║
#  ██║ ╚████║╚██████╔╝╚██████╗   ██║   ██║  ██║███████╗██║██║  ██║
#  ╚═╝  ╚═══╝ ╚═════╝  ╚═════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝╚═╝  ╚═╝
#            noctalia v5 · glass rice · wallpaper-driven colors
#            https://docs.noctalia.dev/v5
let
  wallpaperDir = "${config.xdg.configHome}/noctalia/wallpapers";
in
{
  programs.noctalia = {
    enable = true;
    validateConfig = true;

    settings = {

      shell = {
        lang = "zh-CN";
        font_family = "Noto Sans CJK SC";
        corner_radius_scale = 1.2;
        avatar_path = "~/.face";
        telemetry_enabled = false;
        clipboard_enabled = true;
        clipboard_auto_paste = "off";
        time_format = "{:%I:%M %p}";
        date_format = "%A, %d %B";

        animation = {
          enabled = true;
          speed = 1.0;
        };

        shadow = {
          direction = "down";
          alpha = 0.65;
        };

        panel = {
          transparency_mode = "glass";
          borders = true;
          shadow = true;
          launcher_placement = "floating";
          launcher_position = "center";
          clipboard_placement = "floating";
          clipboard_position = "center";
          control_center_placement = "floating";
          session_placement = "floating";
          session_position = "center";
          floating_offset = 10;
          open_near_click_control_center = true;
        };

        launcher = {
          app_grid = true;
          categories = true;
          show_icons = true;
          sort_by_usage = true;
        };

        screen_corners = {
          enabled = true;
          size = 24;
        };

        screenshot = {
          save_to_file = true;
          copy_to_clipboard = true;
          freeze_screen = true;
          directory = "~/Pictures/Screenshots";
        };
      };

      theme = {
        mode = "dark";
        source = "wallpaper";
        wallpaper_scheme = "m3-tonal-spot";
        templates = {
          builtin_ids = [
            "cava"
            "gtk3"
            "gtk4"
            "kcolorscheme"
            "qt"
            "niri"
            "foot"
            "btop"
            "starship"
          ];
        };
      };

      wallpaper = {
        enabled = true;
        directory = wallpaperDir;
        fill_mode = "crop";
        transition = [ "fade" "disc" "stripes" "wipe" "zoom" "honeycomb" ];
        transition_duration = 1500;
        edge_smoothness = 0.3;
        transition_on_startup = true;
      };

      wallpaper.automation = {
        enabled = false;
        order = "random";
      };

      weather = {
        enabled = true;
        unit = "celsius";
        effects = true;
      };

      location = {
        auto_locate = false;
        address = "Huizhou, Guangdong, China";
      };

      nightlight = {
        enabled = true;
        force = false;
        temperature_day = 4300;
        temperature_night = 3800;
      };

      notification = {
        enable_daemon = true;
        layer = "overlay";
        background_opacity = 0.9;
        offset_x = 16;
        offset_y = 12;
      };

      osd = {
        orientation = "vertical";
        position_vertical = "center_right";
        position = "top_right";
        background_opacity = 0.9;
        offset_x = 16;
        offset_y = 12;
      };

      audio = { enable_overdrive = false; };
      brightness = { enable_ddcutil = false; };
      battery = { warning_threshold = 40; };

      lockscreen = {
        enabled = true;
        blurred_desktop = true;
        blur_intensity = 0.8;
        tint_intensity = 0.4;
      };

      idle = {
        behavior = {
          "screen-off" = {
            enabled = true;
            timeout = 300;
            command = "brightnessctl -s set 10%";
            resume_command = "brightnessctl -r";
          };
          lock = {
            enabled = true;
            timeout = 960;
            command = "hyprlock";
          };
          suspend = {
            enabled = true;
            timeout = 1140;
            command = "systemctl suspend";
          };
        };
      };

      hot_corners = {
        enabled = false;
      };

      control_center = {
        shortcuts = [
          { type = "wifi"; }
          { type = "bluetooth"; }
          { type = "caffeine"; }
          { type = "power_profile"; }
          { type = "nightlight"; }
          { type = "wallpaper"; }
        ];
      };

      dock = {
        enabled = false;
      };

      bar = {
        main = {
          position = "top";
          thickness = 32;
          background_opacity = 0.6;
          margin_edge = 0;
          margin_ends = 0;
          padding = 10;
          widget_spacing = 10;
          radius = 10;
          shadow = true;
          auto_hide = false;
          reserve_space = true;
          font_weight = 600;

          start = [
            "control-center"
            "gap"
            "clock"
            "gap"
            "weather"
            "gap"
            "gap"
            "active_window"
          ];
          center = [ "workspaces" ];
          end = [
            "media"
            "media_viz"
            "gap"
            "cpu"
            "ram"
            "gap"
            "network"
            "bluetooth"
            "volume"
            "microphone"
            "brightness"
            "gap"
            "gap"
            "tray"
            "clipboard"
            "notifications"
            "gap"
            "battery"
            "caffeine"
            "session"
          ];
        };
      };

      widget = {
        "control-center" = {
          use_distro_icon = false;
          custom_image = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          custom_image_colorize = true;
        };

        # 調整為更簡短的格式 (月/日 星期)，避免頂端欄位空間不足
        clock = {
          format = "{:%H:%M:%S}  󰃭 {:%m/%d} {:%a}";
          tooltip_format = "{:%A, %d %B %Y — %I:%M:%S %p}";
          color = "primary";
        };

        weather = {
          show_condition = true;
          show_temperature = true;
          color = "tertiary";
        };

        gap = {
          type = "spacer";
          length = 16;
        };

        media = {
          min_length = 80;
          max_length = 150;
          art_size = 24;
          title_scroll = "always";
          hide_when_no_media = true;
        };

        media_viz = {
          type = "audio_visualizer";
          width = 60;
          bands = 20;
          mirrored = true;
          centered = true;
          show_when_idle = false;
          color_1 = "primary";
          color_2 = "tertiary";
        };

        active_window = {
          label_type = "icon_and_text";
          max_length = 300;
          title_scroll = "on_hover";
          color = "secondary";
        };

        workspaces = {
          label_type = "name";
          max_label_chars = 10;
          labels_only_when_occupied = true;
          focused_color = "primary";
          occupied_color = "tertiary";
          empty_color = "outline";
          pill_scale = 1.0;
          active_pill_size = 2.4;
          hide_when_empty = true;
        };

        tray = { drawer = true; };

        cpu = {
          type = "sysmon";
          stat = "cpu_usage";
          visualization = "gauge";
          show_value = false;
          highlight_color = "error";
        };

        ram = {
          type = "sysmon";
          stat = "ram_pct";
          visualization = "gauge";
          show_value = false;
          highlight_color = "error";
        };

        network = { show_value = true; };
        microphone = {
          type = "volume";
          device = "input";
          mute_color = "error";
        };

        battery = {
          display_mode = "graphic";
          show_value = true;
          warning_color = "error";
        };

        notifications = { hide_when_no_unread = false; };
        session = { icon_color = "error"; };
      };

      desktop_widgets = {
        enabled = false;
      };
    };
  };

  xdg.configFile."noctalia/wallpapers" = {
    source = ../wallpapers;
    recursive = true;
    force = true;
  };
}
