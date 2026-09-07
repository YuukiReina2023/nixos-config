{ ... }:
{
  home.file.".local/bin/niri-screenshot.sh" = {
    source = ../scripts/niri-screenshot.sh;
    executable = true;
  };

  # GitHub 镜像加速：使用 fastgit / raw.fastgit 以及 ghproxy 作为备用
  home.file.".gitconfig".text = ''
    [url "https://hub.fastgit.org/"]
      insteadOf = https://github.com/
    [url "git@hub.fastgit.org:"]
      insteadOf = git@github.com:
    [url "https://raw.fastgit.org/"]
      insteadOf = https://raw.githubusercontent.com/
    # 备用：ghproxy（如需启用可取消注释）
    # [url "https://ghproxy.com/https://github.com/"]
    #   insteadOf = https://github.com/
  '';
}
