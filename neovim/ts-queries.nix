{ vimUtils, stdenv }:
vimUtils.buildVimPlugin {
  pname = "ts-queries";
  version = "dev";
  src = ../files/ts-queries;
  meta = {
    maintainers = [ stdenv.lib.maintainers.leo60228 ];
  };
}
