{
  description = "NixOS Configuration";

  inputs = {
    # 使用清华大学镜像源
    nixpkgs.url = "git+https://mirrors.tuna.tsinghua.edu.cn/git/nixpkgs.git?ref=nixos-unstable";

    # 通过 gh-proxy 镜像加速 github input
    home-manager = {
      url = "git+https://gh-proxy.com/https://github.com/nix-community/home-manager.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "git+https://gh-proxy.com/https://github.com/nix-community/nixvim.git";
      # inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "git+https://gh-proxy.com/https://github.com/sodiboo/niri-flake.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "git+https://gh-proxy.com/https://github.com/noctalia-dev/noctalia.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "git+https://gh-proxy.com/https://github.com/nix-community/nur.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    claude-code = {
      url = "git+https://gh-proxy.com/https://github.com/sadjow/claude-code-nix.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    burpsuitepro = {
      url = "git+https://gh-proxy.com/https://github.com/xiv3r/Burpsuite-Professional.git";
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
                # 修复 niri-flake 引用已废弃 libdisplay-info_0_2 的修补 Overlay
                (final: prev: {
                  libdisplay-info_0_2 = prev.libdisplay-info or prev.libdisplay-info_0_3;
                })
              ];
              nixpkgs.config.allowUnfree = true;

              environment.systemPackages = [
                # 使用 overlay 扩展后的 pkgs 引用 claude-code
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

              # 修正为小写用户名
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
