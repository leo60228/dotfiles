self: super:

rec {
  pulseaudioFull = self.callPackage ../pulseaudio.nix {
    inherit (self.darwin.apple_sdk.frameworks) CoreServices AudioUnit Cocoa;
    x11Support = true;
    jackaudioSupport = true;
    airtunesSupport = true;
    bluetoothSupport = true;
    remoteControlSupport = true;
    zeroconfSupport = true;
  };
}
