self: super: {
  wineWow64Packages = super.wineWow64Packages.extend (
    self': super': {
      unstable = super'.unstable.overrideAttrs (oldAttrs: {
        patches = oldAttrs.patches or [ ] ++ [
          (self.fetchpatch {
            url = "https://raw.githubusercontent.com/Arecsu/wine-affinity/refs/heads/main/0006-comdlg32-use-XDG-Desktop-Portal-for-native-file-dial.patch";
            hash = "sha256-TJHQjeS0puNulfKvlKn5EcpzEFn/onQGg061tczKsF8=";
          })
          (self.fetchpatch {
            url = "https://raw.githubusercontent.com/Arecsu/wine-affinity/refs/heads/main/0007-comdlg32-fix-portal-dialog-compatibility-and-respons.patch";
            hash = "sha256-JEGZ5fPORBbOE8ATsAQ2T5McaOrccr6JAZJKOlYaKbw=";
          })
        ];
      });
    }
  );
}
