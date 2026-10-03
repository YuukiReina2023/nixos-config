{ ... }:
{
  programs.hyfetch = {
    enable = true;
    settings = {
      preset = "transgender";
      mode = "rgb";
      backend = "neofetch";
      color_align = {
        mode = "horizontal";
      };
      distro = "nixos_old";
      pride_month_disable = false;
    };
  };
}
