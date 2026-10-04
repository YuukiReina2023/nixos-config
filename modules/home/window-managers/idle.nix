{ pkgs, ... }:
{
  # 通用 Wayland 空闲与休眠管理守护进程（专为 Niri + Noctalia 桌面打造）
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "noctalia msg session lock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "niri msg action power-on-monitors";
      };

      listener = [
        {
          timeout = 300; # 5 min → 降低屏幕亮度 (dim screen)
          on-timeout = "brightnessctl -s set 20%";
          on-resume = "brightnessctl -r";
        }
        {
          timeout = 600; # 10 min → 锁定会话 (唤起 Noctalia 原生锁屏)
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 900; # 15 min → 关闭显示器 (Niri 熄屏)
          on-timeout = "niri msg action power-off-monitors";
          on-resume = "niri msg action power-on-monitors";
        }
        {
          timeout = 2400; # 40 min → 无操作进入睡眠 (suspend)
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };

  # 确保 hypridle 软件包可用
  home.packages = [ pkgs.hypridle ];
}
