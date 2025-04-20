self: super:

{
  calibre = super.calibre.overrideAttrs (oldAttrs: {
    doInstallCheck = self.stdenv.isx86_64;
  });
}
