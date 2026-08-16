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
      jf-open-huninn-font # 粉圓字體 (jf open 粉圓)

      nerd-fonts.jetbrains-mono
      nerd-fonts.fira-code
      nerd-fonts.hack
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "JetBrainsMono Nerd Font" ];
        serif = [ "jf open huninn" "Noto Serif CJK SC" ];
        sansSerif = [ "jf open huninn" "Noto Sans CJK SC" ];
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
