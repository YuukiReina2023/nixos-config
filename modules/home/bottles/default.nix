{ pkgs, ... }:
{
  # Bottles - 基於 Wine 的 Windows 應用程式管理工具
  home.packages = with pkgs; [
    bottles
    # Wine 的 X11 剪貼簿：winex11.drv 會偵測並使用 xclip 作為剪貼簿管理器，
    # 否則複製內容在來源應用關閉後會遺失，導致貼上偶發失敗或與 Wayland 應用無法互通
    xclip
    # Wayland 剪貼簿工具（cliphist 依賴，明確列出以保證可用）
    wl-clipboard
  ];
}