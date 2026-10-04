{ ... }:
{
  # 锁屏已全面迁移至 Noctalia 原生锁屏 (Greeter 界面：noctalia msg session lock)
  # 停用 hyprlock 及其壁纸同步服务
  programs.hyprlock.enable = false;
}
