self: super:

{
  leoenv = super.hiPrio super.buildEnv {
    name = "leoenv";
    paths = [self.julia (self.python36.withPackages (ps: with ps; [ pyusb ])) self.python27 self.obs-studio self.vlc self.multimc self.dolphinEmuMaster self.openalSoft self.multimc self.vimHugeX self.openscad self.dpkg self.binutils-unwrapped self.slic3r-prusa3d self.sdcc self.mgba self.androidsdk self.androidndk self.filezilla self.rustup self.nasm self.grub2 self.xorriso self.qemu self.discord self.google-chrome-beta self.gitAndTools.git-annex self.gitAndTools.gitFull self.mr self.stow self.file self.gpx self.pciutils self.unzip self.tigervnc self.usbutils self.dotnetPackages.Nuget (self.wine.override { wineBuild = "wineWow"; }) self.nodejs-9_x self.gnumake self.gcc self.meteor self.hplip self.virtualbox self.dotnet-sdk];
  };
}
