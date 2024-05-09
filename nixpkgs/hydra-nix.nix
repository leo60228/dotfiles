self: super:

{
    hydra_unstable = super.hydra_unstable.override { nix = self.nixVersions.nix_2_19; };
}
