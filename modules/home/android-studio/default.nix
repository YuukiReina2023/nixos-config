{ pkgs, ... }:
let
  # 谷歌反重力 (Google Antigravity) 插件生态：
  # 1. Antigravity CLI Companion (dev.matasar.antigravity-companion)
  #    在 Android Studio 内嵌终端中协同 Google Antigravity CLI (agy)，
  #    并通过 MCP (Model Context Protocol) 实时共享代码选区、活动标签页与诊断上下文。
  antigravityCompanion = pkgs.fetchzip {
    name = "antigravity-companion-1.6.0";
    url = "https://plugins.jetbrains.com/plugin/download?rel=true&updateId=1157590";
    extension = "zip";
    hash = "sha256-FtmUCOXpRy12J9vo6+Kj6bmpabMCBb1NNaDAIbSqKnA=";
  };

  # 2. Switch2Antigravity (com.github.ppphuang.idea-antigravity-plugin)
  #    一键将 Android Studio 中正在编辑的工程/文件及光标位置无缝跳转同步至 Google Antigravity 编辑器。
  switch2Antigravity = pkgs.fetchzip {
    name = "Switch2Antigravity-1.0.1";
    url = "https://plugins.jetbrains.com/plugin/download?rel=true&updateId=919408";
    extension = "zip";
    hash = "sha256-iOZLFhx7+kO2A1Vd3uk/LizGeY8T1YX5rYNIUVrsEl0=";
  };
in
{
  # Android Studio 官方集成开发环境
  home.packages = with pkgs; [
    android-studio
  ];

  # 声明式预装 Google Antigravity 插件至 Android Studio 用户插件目录
  # 路径匹配 Android Studio 2026.1 (IntelliJ 平台 XDG 规范)
  home.file = {
    ".local/share/Google/AndroidStudio2026.1.3/antigravity-companion".source = antigravityCompanion;
    ".local/share/Google/AndroidStudio2026.1.3/Switch2Antigravity".source = switch2Antigravity;
  };

  # 插件生态与汉化配置说明：
  # 1. 谷歌反重力 (Google Antigravity) 插件体系：
  #    - Antigravity CLI Companion：在 IDE 终端呼出 agy 并通过 MCP 同步活动文件与诊断。
  #    - Switch2Antigravity：通过快捷键 (Shift+Alt+A) 或右键菜单快速跳转至 Antigravity。
  #    - 原生 ACP / BYOA 协同：Android Studio 内置支持连接本地 agy 智能体客户端进行跨平台调试与构建自愈。
  # 2. 官方中文语言包 (Chinese Simplified Language Pack)：
  #    - 插件 ID：com.intellij.zh
  #    - 安装方式：启动 Android Studio -> 欢迎界面「Plugins」（或 Settings -> Plugins）->
  #      在 Marketplace 搜索「Chinese (Simplified) Language Pack」点击 Install 并重启即可完成完整中文化。
}
