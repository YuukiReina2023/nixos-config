{ ... }:
{
  services.hypridle = {
    # 預設使用 Niri + Noctalia 桌面外殼，閒置/鎖定由 Noctalia 內建的 idle 管理，停用 hypridle 避免執行失效的 hyprctl
    enable = false;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };

      listener = [
        {
          timeout = 300; # 5 min → dim screen
          on-timeout = "brightnessctl -s set 20%";
          on-resume = "brightnessctl -r";
        }
        {
          timeout = 600; # 10 min → lock
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 900; # 15 min → screen off
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };
}
