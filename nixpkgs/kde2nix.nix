{ kde2nix, ... }:
self: super:
{
    kde2nix = kde2nix.packages.${self.targetPlatform.system};
}
