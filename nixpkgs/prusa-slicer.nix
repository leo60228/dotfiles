{ nixpkgs-unstable, ... }:
self:
super:

{
  prusa-slicer = self.callPackage "${nixpkgs-unstable}/pkgs/applications/misc/prusa-slicer" {
    copyDesktopItems = self.makeSetupHook { } "${nixpkgs-unstable}/pkgs/build-support/setup-hooks/copy-desktop-items.sh";
  };
}
