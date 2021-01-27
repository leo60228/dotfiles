self: super:
let
    syncthingPackages = self.callPackage ../syncthing {};
in {
    inherit (syncthingPackages) syncthing syncthing-cli syncthing-discovery syncthing-relay;
}
