self: super:

{
    latte-dock = super.latte-dock.overrideAttrs (oldAttrs: rec {
        pname = "latte-dock";
        version = "0.10.4";

        src = self.fetchurl {
            url = "https://download.kde.org/stable/${pname}/${pname}-${version}.tar.xz";
            sha256 = "XRop+MNcbeCcbnL2LM1i67QvMudW3CjWYEPLkT/qbGM=";
            name = "${pname}-${version}.tar.xz";
        };
    });
}
