self: super: {
    xorg = super.xorg // {
        xf86videoamdgpu = (import <unstable> {}).xorg.xf86videoamdgpu.override {
            inherit (self) stdenv pkgconfig fetchurl libGL libdrm udev;
            inherit (self.xorg) xorgproto xorgserver;
            mesa = (import /home/leo60228/nixpkgs-navi {}).mesa;
        };
    };
}
