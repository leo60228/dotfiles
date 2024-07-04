{
  stdenv,
  lib,
  fetchurl,
  coccinelle,
  kernel,
  kmod,
}:

let
  ver = "7.27.1.40643";
in
stdenv.mkDerivation rec {
  pname = "datapath-vision";
  version = "${ver}-${kernel.version}";

  src = fetchurl {
    url = "https://www.datapathsoftware.com/supportdownloads/linux/vision-driver-app/VisionInstall-${ver}.tar.gz";
    sha256 = "1995klvpvps3k25w0ly1qvhm9n73ad58yp87ln2n34nrf3bynhiq";
  };

  sourceRoot = ".";

  postPatch = ''
    substituteInPlace scripts/rgb133config.sh --replace-fail '/boot/config-$KVER' "${kernel.configfile}"
    substituteInPlace src/rgb133ioctl.c --replace-fail 'strlcpy' 'strscpy'
    substituteInPlace src/rgb133sndcard.c --replace-fail 'strlcpy' 'strscpy'
    cat >> src/rgb133kernel.c << EOF
    size_t strlcpy(char *dest, const char *src, size_t size)
    {
      size_t ret = strlen(src);

      if (size) {
        size_t len = (ret >= size) ? size - 1 : ret;
        memcpy(dest, src, len);
        dest[len] = '\0';
      }
      return ret;
    }
    EOF
    spatch --sp-file "${./vm_flags.cocci}" --dir src --in-place
    spatch --sp-file "${./snd_card_free.cocci}" --dir src --in-place
    spatch --sp-file "${./get_user_pages.cocci}" --dir src --in-place
    # patch from https://marc.info/?l=kernel-janitors&m=159285076616726&w=4
    # (coccinelle used at build time to avoid redistribution)
    spatch --sp-file "${./dma-changes.cocci}" --dir src --in-place
  '';

  preBuild = ''
    for blob in rgb133 dgc133sys; do
      if ! grep -q PREEMPT_RT=y "${kernel.configfile}"; then
        cp -v bin/$blob.$(getconf LONG_BIT).a bin/$blob.o
      else
        cp -v bin/$blob.$(getconf LONG_BIT).RT.a bin/$blob.o
      fi
      touch bin/.$blob.o.cmd
    done
  '';

  hardeningDisable = [
    "pic"
    "format"
  ];
  nativeBuildInputs = [ coccinelle ] ++ kernel.moduleBuildDependencies;

  env.NIX_CFLAGS_COMPILE = "-Wno-error=attributes";

  makeFlags = kernel.makeFlags ++ [
    "KERNELDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}"
    "INSTALL_MOD_PATH=$(out)"
    "INSTALL_MOD_DIR=kernel/drivers/media/pci/datapath"
  ];

  installTargets = [ "modules_install" ];

  meta = with lib; {
    description = "Driver for Vision/VisionAV/VisionSC capture cards";
    homepage = "https://www.datapathsoftware.com/downloads/";
    license = licenses.unfree;
    maintainers = with maintainers; [ leo60228 ];
    platforms = platforms.linux;
  };
}
