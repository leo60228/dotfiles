self: super: {
  hydra = super.hydra.overrideAttrs (
    oldAttrs:
    let
      inherit (oldAttrs.passthru) perlDeps;
      newPerlDeps = perlDeps.override {
        paths = map (
          x:
          if x ? pname && x.pname == "OIDC-Lite" then
            x.overrideAttrs (oldAttrs: {
              doCheck = false;
            })
          else
            x
        ) perlDeps.paths;
      };
      patchInputs = inputs: map (x: if x.name == "hydra-perl-deps" then newPerlDeps else x) inputs;
    in
    {
      nativeBuildInputs = patchInputs oldAttrs.nativeBuildInputs;
      buildInputs = patchInputs oldAttrs.buildInputs;
      passthru.perlDeps = newPerlDeps;
    }
  );
}
