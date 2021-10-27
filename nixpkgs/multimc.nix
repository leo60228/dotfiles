self: super: {
    multimc = (self.libsForQt5.callPackage ../multimc.nix {
        msaClientID =
            let
                inherit (self.lib) elemAt mod range lowerChars upperChars replaceStrings;
                alphaRange = range 0 25;
                rot13Index = x: mod (x + 13) 26;
                rot13Lookup = alpha: x: elemAt alpha (rot13Index x);
                makeRot13Alphabet = alpha: map (rot13Lookup alpha) alphaRange;
                lowerRot13 = makeRot13Alphabet lowerChars;
                upperRot13 = makeRot13Alphabet upperChars;
                allChars = lowerChars ++ upperChars;
                allRot13 = lowerRot13 ++ upperRot13;
                rot13 = replaceStrings allChars allRot13;

                rot13ClientID = "7q151180-o320-4341-852s-q746764r7r0q";
            in
                rot13 rot13ClientID;
    }).overrideAttrs (oldAttrs: {
        patches = oldAttrs.patches ++ [ ../files/multimc-png-logo.patch ];
        postPatch = oldAttrs.postPatch + ''
        mkdir -v launcher/resources/multimc/512x512
        cp -v ${../files/multimc.png} launcher/resources/multimc/512x512/logo.png
        '';
    });
}
