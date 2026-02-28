self: super: {
  pythonPackagesExtensions = super.pythonPackagesExtensions ++ [
    (self': super': {
      requests-ratelimiter =
        assert super'.requests-ratelimiter.meta.broken;
        super'.requests-ratelimiter.override {
          pyrate-limiter = self'.pyrate-limiter_2;
        };
    })
  ];
}
