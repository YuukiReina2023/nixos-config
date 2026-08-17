{
  description = "NixOS Configuration";

  inputs = {
    # 使用清华大学镜像源
    nixpkgs.url = "git+https://mirrors.tuna.tsinghua.edu.cn/git/nixpkgs.git?ref=nixos-unstable";

    # 使用官方 GitHub URL，不经过第三方代理
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/nur";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    claude-code = {
      url = "github:sadjow/claude-code-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    burpsuitepro = {
      url = "github:xiv3r/Burpsuite-Professional";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      nixvim,
      nur,
      claude-code,
      burpsuitepro,
      ...
    }:
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./modules/system/default.nix
          ./hardware-configuration.nix
          inputs.niri.nixosModules.niri

          # 系统层级配置与 Overlay 注入
          (
            { pkgs, ... }:
            {
              nixpkgs.overlays = [
                nur.overlays.default
                claude-code.overlays.default
              ];
              nixpkgs.config.allowUnfree = true;

              environment.systemPackages = [
                pkgs.claude-code
              ];
            }
          )

          # Home Manager 模块配置
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;

              extraSpecialArgs = {
                inherit nixvim inputs;
              };

              users.yuukireina2023 = import ./modules/home/default.nix;
              backupFileExtension = "backup";

              sharedModules = [
                nixvim.homeModules.nixvim
                inputs.noctalia.homeModules.default
              ];
            };
          }
        ];
      };
    };
}
