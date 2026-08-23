# fcitx5 - 輸入法框架(中文拼音等)
{ pkgs, ... }:

{
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      addons = with pkgs; [
        fcitx5-mellow-themes
        qt6Packages.fcitx5-chinese-addons
      ];
      waylandFrontend = true;
      settings = {
        globalOptions = {
          "Hotkey/TriggerKeys" = {
            "0" = "Shift_L"; # 改为左 Shift 切换
          };
        };
        inputMethod = {
          GroupOrder."0" = "Default";
          "Groups/0" = {
            Name = "Default";
            "Default Layout" = "us";
            DefaultIM = "pinyin";
          };
          "Groups/0/Items/0".Name = "keyboard-us";
          "Groups/0/Items/1".Name = "pinyin";
        };
        addons = {
          classicui.globalSection = {
            "Vertical Candidate List" = "False";
            WheelForPaging = "True";
            Font = ''"Sans 10"'';
            MenuFont = ''"Sans 10"'';
            TrayFont = ''"Sans Bold 10"'';
            TrayOutlineColor = "#000000";
            TrayTextColor = "#ffffff";
            PreferTextIcon = "False";
            ShowLayoutNameInIcon = "True";
            UseInputMethodLanguageToDisplayText = "True";
            Theme = "kwinblur-mellow-sakura";
            DarkTheme = "kwinblur-mellow-sakura-dark";
            UseDarkTheme = "True";
            UseAccentColor = "True";
            PerScreenDPI = "False";
            ForceWaylandDPI = 0;
            EnableFractionalScale = "True";
          };
          pinyin.globalSection = {
            PageSize = 9;
            CloudPinyinEnabled = "True";
          };
          chttrans.globalSection = {
            Engine = "OpenCC";
            EnabledIM = "";
            OpenCCS2TProfile = "default";
            OpenCCT2SProfile = "default";
          };
          punctuation.globalSection = {
            HalfWidthPuncAfterLetterOrNumber = "True";
            TypePairedPunctuationsTogether = "False";
            Enabled = "True";
          };
          # XIM 支援：Wine 應用（Bottles）在 XWayland 下透過 XIM 協定使用 fcitx5，
          # 需搭配 XMODIFIERS="@im=fcitx" 環境變數（已在 modules/home/default.nix 全域設定）
          xim.globalSection = {
            UseXim = "True";
          };
        };
      };
    };
  };
}
