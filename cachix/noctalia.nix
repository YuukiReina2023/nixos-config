
{
  nix = {
    settings = {
      substituters = lib.mkForce [ "https://noctalia.cachix.org" ];
      trusted-public-keys = lib.mkForce [ "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=" ];
    };
  };
}
