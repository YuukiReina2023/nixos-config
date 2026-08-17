{ pkgs, ... }:
{
  programs.fish.enable = true;

  users.users.yuukireina2023 = {
    isNormalUser = true;
    description = "yuukireina2023";
    group = "yuukireina2023"; # 明确指定主组名称
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

  # 建立对应的同名主组
  users.groups.yuukireina2023 = {};
}