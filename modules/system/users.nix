{ pkgs, ... }:
{


  programs.fish.enable = true;

  users.users.YuukiReina2023 = {
    isNormalUser = true;
    description = "YuukiReina2023";
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "audio"
      "docker"
      "wireshark"
    ];
    # shell = pkgs.bash;
    shell = pkgs.fish;
  };
}
