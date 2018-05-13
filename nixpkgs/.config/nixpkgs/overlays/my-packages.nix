self: super:

{
  leoenv = super.hiPrio super.buildEnv {
    name = "leoenv";
    paths = [self.mono58 self.julia (self.python36.withPackages (ps: with ps; [ pyusb ])) self.python27 self.obs-studio self.vlc self.multimc self.jetbrains.jdk self.libreoffice self.dolphinEmuMaster self.openalSoft self.multimc self.vimHugeX self.openscad self.dpkg self.binutils-unwrapped self.xorg_sys_opengl self.slic3r-prusa3d self.sdcc self.mgba self.androidsdk self.androidndk self.filezilla self.rustup self.nasm self.grub2 self.xorriso self.qemu self.discord self.google-chrome-beta self.gitAndTools.git-annex self.gitAndTools.gitFull self.mr self.stow];
  };
}
