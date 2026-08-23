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

  # Wine 應用在 XWayland（xwayland-satellite）下使用 XIM 協定輸入，
  # 需確保 fcitx5 的 XIM 環境變數傳入 Bottles 啟動的 Wine 程序。
  # 這些變數已在 modules/home/default.nix 全域設定，此處明確列出以利維護。
  home.sessionVariables = {
    XMODIFIERS = "@im=fcitx";
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    QT_IM_MODULES = "wayland;fcitx";
  };
}