
# WARN: this file will get overwritten by $ cachix use <name>
{ pkgs, lib, ... }:

let
  # Explicitly include the generated cachix files so their nix.settings are
  # merged by NixOS. This avoids depending on runtime readDir/filter behavior
  # which can miss files when flakes/evaluation interacts with the FS.
  imports = [ ./cachix/nix-community.nix ./cachix/noctalia.nix ];
in {
  inherit imports;

  # Keep the official cache available alongside the Cachix caches.
  nix.settings = lib.mkMerge [
    { extra-substituters = [ "https://cache.nixos.org" ]; }
  ];
}
