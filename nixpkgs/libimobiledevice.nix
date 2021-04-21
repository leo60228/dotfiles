self: super: {
  libplist = self.callPackage ../libplist.nix { };
  libusbmuxd = self.callPackage ../libusbmuxd.nix { };
  libimobiledevice = self.callPackage ../libimobiledevice.nix { };
  usbmuxd = self.callPackage ../usbmuxd.nix { };
}
