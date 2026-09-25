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

                # niri-flake 的 niri-stable (v25.08) 連結 libdisplay-info-sys 0.2.2，
                # 需要系統 libdisplay-info 0.2.x。nixpkgs 已移除 libdisplay-info_0_2
                # （僅保留 _0_3 與 0.4），並留下會 throw 的 alias，
                # 導致 niri-flake 的 `libdisplay-info_0_2 ? libdisplay-info` 預設值失效
                # （callPackage 仍會找到該屬性）且其 `assert libdisplay-info_0_2.version == "0.2.0"`
                # 在評估時爆炸。重新建置 0.2.0（而非指向 _0_3）是刻意的：
                # 0.3 對該 crate 而言是 ABI 不相容。
                # 上游：https://github.com/sodiboo/niri-flake/issues/1851
                # 修復進行中：https://github.com/sodiboo/niri-flake/pull/1853
                # 待該 PR 合併並更新 niri-flake 鎖定後即可移除。
                (final: prev: {
                  libdisplay-info_0_2 = prev.libdisplay-info.overrideAttrs {
                    version = "0.2.0";
                    src = prev.fetchFromGitLab {
                      domain = "gitlab.freedesktop.org";
                      owner = "emersion";
                      repo = "libdisplay-info";
                      rev = "0.2.0";
                      hash = "sha256-6xmWBrPHghjok43eIDGeshpUEQTuwWLXNHg7CnBUt3Q=";
                    };
                  };
                })
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
