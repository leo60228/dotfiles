self: super: rec {
    mastodonUpstream = self.callPackage ../mastodon {};
    mastodon = mastodonUpstream.override {
        version = import ../glitch-soc/version.nix;
        srcOverride = self.callPackage ../glitch-soc/source.nix {};
        dependenciesDir = ../glitch-soc;
    };
}
