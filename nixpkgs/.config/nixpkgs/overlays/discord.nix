self: super:

{
  discord = super.discord.overrideAttrs (oldAttrs: rec {
    version = "0.0.5";
    name = "${oldAttrs.pname}-${version}";
    src = super.fetchurl {
      url = "https://cdn.discordapp.com/apps/linux/${version}/${oldAttrs.pname}-${version}.tar.gz";
      sha256 = "067gb72qsxrzfma04njkbqbmsvwnnyhw4k9igg5769jkxay68i1g";
    };
  });
}
