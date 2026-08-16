{ pkgs, ... }:
{
  fonts = {
    enableDefaultPackages = false;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      montserrat
      liberation_ttf
      carlito
      caladea
      lxgw-wenkai
      arphic-ukai
      wqy_microhei
      dejavu_fonts
      corefonts

      nerd-fonts.jetbrains-mono
      nerd-fonts.fira-code
      nerd-fonts.hack
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "JetBrainsMono Nerd Font" ];
        serif = [ "Noto Serif CJK SC" ];
        sansSerif = [ "WenQuanYi Micro Hei" ];
        emoji = [ "Noto Color Emoji" ];
      };
      localConf = ''
        <?xml version="1.0"?>
        <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
        <fontconfig>
          <alias><family>楷体_GB2312</family><prefer><family>LXGW WenKai</family><family>AR PL UKai CN</family></prefer></alias>
          <alias><family>楷体</family><prefer><family>LXGW WenKai</family><family>AR PL UKai CN</family></prefer></alias>
          <alias><family>KaiTi</family><prefer><family>LXGW WenKai</family><family>AR PL UKai CN</family></prefer></alias>
          <alias><family>KaiTi_GB2312</family><prefer><family>LXGW WenKai</family><family>AR PL UKai CN</family></prefer></alias>
        </fontconfig>
      '';
    };
  };
}
