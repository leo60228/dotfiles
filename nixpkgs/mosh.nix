self:
super:

{
    mosh = super.mosh.overrideAttrs (oldAttrs: rec {
        pname = "mosh-unstable";
        name = "${pname}-${oldAttrs.version}";

        patches = builtins.map (builtins.elemAt oldAttrs.patches) [ 0 1 2 4 ];

        src = self.fetchFromGitHub {
            owner = "mobile-shell";
            repo = "mosh";
            rev = "e023e81c08897c95271b4f4f0726ec165bb6e1bd";
            sha256 = "X2xJCiC5/vSijzZgQsWDzD+R8D8ppdZD6WeG4uoxyYw=";
        };

        postPatch = ''
            substituteInPlace scripts/mosh.pl \
                --subst-var-by ssh "${self.openssh}/bin/ssh" \
                --subst-var-by mosh-client "$out/bin/mosh-client"
        '';
    });
}
