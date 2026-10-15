{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode-fhs;

    profiles.default = {
      enableExtensionUpdateCheck = false;
      enableUpdateCheck = false;

      extensions = with pkgs.vscode-extensions; [
        # 1. 界面汉化
        ms-ceintl.vscode-language-pack-zh-hans

        # 2. Nix 语言支持与开发环境
        jnoortheen.nix-ide
        mkhl.direnv

        # 3. 前端与 Web 全栈开发
        dbaeumer.vscode-eslint
        esbenp.prettier-vscode
        bradlc.vscode-tailwindcss
        formulahendry.auto-rename-tag

        # 4. 后端开发生态 (匹配系统与 devshell 技术栈)
        ms-python.python
        golang.go
        prisma.prisma
        ms-azuretools.vscode-docker
        tamasfe.even-better-toml
        redhat.vscode-yaml

        # 5. 开发效能与 Git 辅助
        usernamehw.errorlens
        eamodio.gitlens

        # 6. 主题与图标 (契合系统的 Tokyo Night 风格)
        enkia.tokyo-night
        pkief.material-icon-theme
      ];

      userSettings = {
        # 语言与主题外观
        "locale" = "zh-cn";
        "workbench.colorTheme" = "Tokyo Night";
        "workbench.iconTheme" = "material-icon-theme";
        "workbench.startupEditor" = "none";

        # 编辑器核心体验
        "editor.fontSize" = 14;
        "editor.fontFamily" = "'JetBrainsMono Nerd Font', 'FiraCode Nerd Font', monospace";
        "editor.fontLigatures" = true;
        "editor.smoothScrolling" = true;
        "editor.cursorBlinking" = "smooth";
        "editor.cursorSmoothCaretAnimation" = "on";
        "editor.bracketPairColorization.enabled" = true;
        "editor.guides.bracketPairs" = "active";
        "editor.formatOnSave" = true;

        # 代码格式化与语言服务
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
        "[nix]" = {
          "editor.defaultFormatter" = "jnoortheen.nix-ide";
        };
        "[go]" = {
          "editor.defaultFormatter" = "golang.go";
        };
        "[python]" = {
          "editor.defaultFormatter" = "ms-python.python";
        };

        # Nix IDE 整合 nixd
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nixd";

        # 禁用内部自带检查与自动更新，交由 Nix 管理
        "extensions.autoCheckUpdates" = false;
        "update.mode" = "none";
      };
    };
  };
}
