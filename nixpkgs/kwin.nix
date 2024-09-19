self: super:

{
  kdePackages = super.kdePackages.overrideScope (
    self': super': {
      kwin = super'.kwin.overrideAttrs (oldAttrs: {
        patches = oldAttrs.patches ++ [ ../files/kwin-chromium-vrr.patch ];
      });
    }
  );
}
