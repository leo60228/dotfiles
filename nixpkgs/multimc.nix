self: super: {
    multimc = super.multimc.overrideAttrs (oldAttrs: {
        patches = [ ../files/multimc-png-logo.patch ];
        postPatch = ''
        mkdir -v application/resources/multimc/512x512
        cp -v ${../files/multimc.png} application/resources/multimc/512x512/logo.png
        '';
    });
}
