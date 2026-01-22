self: super:

{
  picard = super.picard.overrideAttrs (oldAttrs: {
    patches = (oldAttrs.patches or [ ]) ++ [ ../files/picard-scsitoc.patch ];
  });
}
