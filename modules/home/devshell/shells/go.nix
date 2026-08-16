{ pkgs }:
pkgs.mkShell {
  buildInputs = with pkgs; [
    go
    gopls
    delve
    golangci-lint
    gotests
    gofumpt
    govulncheck
    air
  ];

  shellHook = ''
    echo "Go $(go version | cut -d' ' -f3) loaded"
  '';
}
