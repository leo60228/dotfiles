self: super: {
    xorg = super.xorg // {
        xf86videoamdgpu = (import <unstable> {}).xorg.xf86videoamdgpu.override {
            inherit (self) stdenv pkgconfig fetchurl mesa libGL libdrm udev;
            inherit (self.xorg) xorgproto xorgserver;
        };
    };
}
