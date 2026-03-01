self: super: {
  pythonPackagesExtensions = super.pythonPackagesExtensions ++ [
    (self': super': {
      requests-ratelimiter =
        assert super'.requests-ratelimiter.meta.broken;
        super'.requests-ratelimiter.override {
          pyrate-limiter = self'.pyrate-limiter_2;
        };
      beets =
        (super'.beets.override {
          sphinxHook = null;
          sphinx-design = null;
          sphinx-copybutton = null;
          sphinx-toolbox = null;
          pydata-sphinx-theme = null;
        }).overrideAttrs
          (oldAttrs: {
            outputs = [
              "out"
              "dist"
            ];
          });
    })
  ];
}
