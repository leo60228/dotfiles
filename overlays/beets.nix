self: super: {
  beetsPackages = super.beetsPackages.extend (
    self': super': {
      beets-minimal = super'.beets-minimal.overrideAttrs (oldAttrs: {
        dontUsePytestCheck = true;
      });
    }
  );
}
