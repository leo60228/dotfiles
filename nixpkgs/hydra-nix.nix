self: super:

{
    hydra = super.hydra.override { nix = self.nixVersions.nix_2_19; };
}
