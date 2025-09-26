self: super:

{
  calibre =
    (super.calibre.override {
      piper-tts = self.piper-tts.override {
        withTrain = false;
      };
    }).overrideAttrs
      (oldAttrs: {
        doInstallCheck = self.stdenv.isx86_64;
      });
}
