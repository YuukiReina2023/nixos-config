{ pkgs, ... }:
{
  # Android Studio 集成开发环境
  # 中文汉化说明：
  # Android Studio 基于 JetBrains 平台构建，官方中文通过官方插件提供。
  # 启动 Android Studio 后，在欢迎界面的「Plugins」或「Settings -> Plugins」中，
  # 在 Marketplace 搜索「Chinese (Simplified) Language Pack」安装并重启即可享受完整中文界面。
  home.packages = with pkgs; [
    android-studio
  ];
}
