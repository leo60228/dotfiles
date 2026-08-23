self: super: {
  wineWow64Packages = super.wineWow64Packages.extend (
    self': super': {
      unstable = super'.unstable.overrideAttrs (oldAttrs: {
        patches = oldAttrs.patches or [ ] ++ [
          (self.fetchpatch {
            url = "https://raw.githubusercontent.com/Arecsu/wine-affinity/3bb23c70fda730fc9d176b37cd116b51f2b3c15b/0006-comdlg32-use-XDG-Desktop-Portal-for-native-file-dial.patch";
            hash = "sha256-TJHQjeS0puNulfKvlKn5EcpzEFn/onQGg061tczKsF8=";
          })
          (self.fetchpatch {
            url = "https://raw.githubusercontent.com/Arecsu/wine-affinity/3bb23c70fda730fc9d176b37cd116b51f2b3c15b/0007-comdlg32-fix-portal-dialog-compatibility-and-respons.patch";
            hash = "sha256-JEGZ5fPORBbOE8ATsAQ2T5McaOrccr6JAZJKOlYaKbw=";
          })
        ];
      });
    }
  );
}
