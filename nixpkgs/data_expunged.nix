{ data_expunged, ... }:
self: super:
{
    inherit (data_expunged.packages.${self.targetPlatform.system}) data_expunged;
}
