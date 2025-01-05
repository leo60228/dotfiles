self: super:

{
  alsa-utils = super.alsa-utils.overrideAttrs (oldAttrs: {
    postFixup =
      oldAttrs.postFixup
      + ''
        sed -i $out/lib/udev/rules.d/*.rules -e 's,/usr/bin/cat,${self.coreutils}/bin/cat,g'
      '';
  });
}
