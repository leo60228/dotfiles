self:
super:

{
    inherit (self.callPackages ../graalvm-ee.nix {}) graalvm8-ee;
}
