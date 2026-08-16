{ pkgs }:
pkgs.mkShell {
  buildInputs = with pkgs; [
    python3
    python3Packages.pip
    uv
  ];

  shellHook = ''
    echo "Python $(python3 --version) loaded"
  '';
}
