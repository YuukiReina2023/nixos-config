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
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:epireyn/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia-greeter = {
      url = "github:noctalia-dev/noctalia-greeter";
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
      self,
      nixpkgs,
      home-manager,
      nixvim,
      nur,
      claude-code,
      burpsuitepro,
      ...
    }:
    let
      mkSystem =
        {
          hostName,
          systemModule,
          extraHomeArgs ? { },
        }:
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs hostName; };
          modules = [
            systemModule
            inputs.niri.nixosModules.niri
            inputs.noctalia-greeter.nixosModules.default

            # 系统层级配置与 Overlay 注入
            (
              { pkgs, ... }:
              {
                nixpkgs.overlays = [
                  nur.overlays.default
                  claude-code.overlays.default
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
                  inherit nixvim inputs hostName;
                } // extraHomeArgs;

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
    in
    {
      nixosConfigurations = rec {
        # 笔记本主机：Razer Blade 15 (Early 2021) - Intel UHD + NVIDIA RTX 3070 Mobile
        blade = mkSystem {
          hostName = "blade";
          systemModule = ./hosts/blade/default.nix;
          extraHomeArgs = {
            gpu = "nvidia";
          };
        };

        # 工作站主机：Dell Precision 7820 Tower - AMD Radeon PRO W6800
        precision = mkSystem {
          hostName = "precision";
          systemModule = ./hosts/precision/default.nix;
          extraHomeArgs = {
            gpu = "amd";
          };
        };

        # 默认回退别名：指向当前笔记本 blade 配置，确保 `nixos-rebuild switch --flake .` 在当前主机名或未指定时直接生效
        nixos = blade;
      };
    };
}
