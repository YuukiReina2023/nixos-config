{ ... }:
{
  home.file.".local/bin/niri-screenshot.sh" = {
    source = ../scripts/niri-screenshot.sh;
    executable = true;
  };

  # 使用官方 GitHub 地址，配置用户信息和凭据助手
  home.file.".gitconfig" = {
    force = true;
    text = ''
      # GitHub should use the official upstream URLs.
      # Third-party mirrors are intentionally disabled because they may fail or block access.
      [user]
        name = YuukiReina2023
        email = yuukireina2023@gmail.com
      [credential]
        helper = store
    '';
  };
}
