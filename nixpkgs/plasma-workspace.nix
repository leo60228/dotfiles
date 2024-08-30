self: super:

{
  kdePackages = super.kdePackages.overrideScope (self': super': {
    plasma-workspace = super'.plasma-workspace.overrideAttrs (oldAttrs: {
      patches = oldAttrs.patches ++ [ ../files/fix-plasma-qalculate.patch ];
    });
  });
}
