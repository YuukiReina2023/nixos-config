{ pkgs, ... }:
{
  programs.fish.enable = true;

  # 将 YuukiReina2023 修改为全小写的 yuukireina2023
  users.users.yuukireina2023 = {
    isNormalUser = true;
    description = "YuukiReina2023";
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
