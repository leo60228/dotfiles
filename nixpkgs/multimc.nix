self: super: {
    multimc = (self.libsForQt5.callPackage ../multimc.nix {}).overrideAttrs (oldAttrs: {
        patches = [ ../files/multimc-png-logo.patch ../files/multimc-legacy-fabric.patch ];
        postPatch = ''
        mkdir -v application/resources/multimc/512x512
        cp -v ${../files/multimc.png} application/resources/multimc/512x512/logo.png
        '';
    });
}
