self:
super:

{
    inherit (self.callPackages ../graalvm-ee.nix {}) graalvm17-ee;
}
