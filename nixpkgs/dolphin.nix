self:
super:
{
  dolphinEmuMaster = self.qt5.callPackage ../dolphin.nix {
    inherit (self.darwin.apple_sdk.frameworks) CoreBluetooth ForceFeedback IOKit OpenGL;
  };
}
