self:
super:

{
    kdeconnect = super.kdeconnect.overrideAttrs (oldAttrs: {
        version = "21.12.0";
        src = self.fetchurl {
            url = "mirror://kde/stable/release-service/21.12.0/src/kdeconnect-kde-21.12.0.tar.xz";
            sha256 = "0jlx6rlg2sspfxq9fsl1416b7229vbx0fydy0a4vdj7nrq1iv7ji";
            name = "kdeconnect-kde-21.12.0.tar.xz";
        };
    });
}
