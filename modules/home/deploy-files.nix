{ ... }:
{
  home.file.".local/bin/niri-screenshot.sh" = {
    source = ../scripts/niri-screenshot.sh;
    executable = true;
  };

  # 使用官方 GitHub 地址，禁用失效的 FastGit / raw.fastgit 重写
  home.file.".gitconfig".text = ''
    # GitHub should use the official upstream URLs.
    # Third-party mirrors are intentionally disabled because they may fail or block access.
  '';
}
