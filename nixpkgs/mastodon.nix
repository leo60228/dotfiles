self: super: rec {
    mastodonUpstream = self.callPackage ../mastodon {};
    mastodon = mastodonUpstream.override {
        srcOverride = self.applyPatches {
            inherit (mastodonUpstream) src;
            patches = [ ../files/mastodon-10k.patch ../files/long-display-name.patch ];
        };
    };
}
