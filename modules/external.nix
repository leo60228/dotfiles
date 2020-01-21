{ ... }: {
  imports = [
    "${builtins.fetchTarball https://github.com/rycee/home-manager/archive/release-19.09.tar.gz}/nixos"
    (builtins.fetchTarball {
      url = "https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/-/archive/v2.2.1/nixos-mailserver-v2.2.1.tar.gz";
      sha256 = "03d49v8qnid9g9rha0wg2z6vic06mhp0b049s3whccn1axvs2zzx";
    })
  ];
}
