{ pkgs }:
pkgs.mkShell {
  buildInputs = with pkgs; [
    nodejs_24
    pnpm
    typescript
  ];

  env = {
    NPM_CONFIG_PREFIX = "$HOME/.npm";
  };

  shellHook = ''
    echo "Node.js $(node --version) loaded"
  '';
}
