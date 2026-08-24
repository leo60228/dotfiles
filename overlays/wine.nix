self: super: {
  wineWow64Packages = super.wineWow64Packages.extend (
    self': super': {
      stable = (super'.stable.override { ffmpegSupport = false; }).overrideAttrs (oldAttrs: {
        src = self.fetchFromGitHub {
          owner = "BananaWorks07";
          repo = "wine-valve";
          rev = "0dbbf9c77d370e2afb4948f83cfcde912b060cc9";
          hash = "sha256-cfIWOpTKE/LRwQ8D5Hrb2kDiEVrXnWb51Gk6Syg2/X4=";
        };
        buildInputs = oldAttrs.buildInputs or [ ] ++ [ self.ffmpeg_4-headless ];
        nativeBuildInputs = oldAttrs.nativeBuildInputs or [ ] ++ [
          self.autoreconfHook
          self.python3
          self.perl
        ];
        patches = [
          (self.fetchpatch {
            url = "https://raw.githubusercontent.com/Arecsu/wine-affinity/3bb23c70fda730fc9d176b37cd116b51f2b3c15b/0006-comdlg32-use-XDG-Desktop-Portal-for-native-file-dial.patch";
            hash = "sha256-TJHQjeS0puNulfKvlKn5EcpzEFn/onQGg061tczKsF8=";
          })
          (self.fetchpatch {
            url = "https://raw.githubusercontent.com/Arecsu/wine-affinity/3bb23c70fda730fc9d176b37cd116b51f2b3c15b/0007-comdlg32-fix-portal-dialog-compatibility-and-respons.patch";
            hash = "sha256-JEGZ5fPORBbOE8ATsAQ2T5McaOrccr6JAZJKOlYaKbw=";
          })
        ];
        preConfigure = ''
          pushd dlls/winevulkan
          XDG_CACHE_HOME="$(mktemp -d)" python3 ./make_vulkan -x vk.xml -X video.xml
          popd
          perl -w ./tools/make_specfiles
        '';
      });
    }
  );
}
