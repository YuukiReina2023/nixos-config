{ pkgs, ... }:
let
  base = import ./shells/base.nix { inherit pkgs; };
  python = import ./shells/python.nix { inherit pkgs; };
  node = import ./shells/node.nix { inherit pkgs; };
  go = import ./shells/go.nix { inherit pkgs; };

  modules = [
    base
    python
    node
    go
  ];
in
{
  home.packages = builtins.concatLists (map (m: m.buildInputs or [ ]) modules);
}
