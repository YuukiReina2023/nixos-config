
{
  nix = {
    settings = {
      substituters = lib.mkForce [ "https://nix-community.cachix.org" ];
      trusted-public-keys = lib.mkForce [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];
    };
  };
}
