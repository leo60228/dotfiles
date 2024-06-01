#!/usr/bin/env sh
# Simple script to create a buildVimPlugin drv for NixOs
# JagaJaga 2014
# Usage ./gitlab2nix.sh repoOwner/repoName (only gitlab is supported)
# Deps: nix-prefetch-scripts

rep="https://gitlab.com/"$1".git"
homepage="https://gitlab.com/"$1
rev=$(git ls-remote "$rep" | head -1 | cut -f1)
name=$(echo "$1" | sed 's/\(.*\)\/\(.*\)/\2/g' | sed 's/^vim-\(.*\)/\1/g' | sed 's/\(.*\)\.vim/\1/g')
#basename=$(echo $name | sed 's/\([a-zA-Z]\+\)[-_\.]\([a-zA-Z]\)\([a-zA-Z]\+\)/\1\U\2\L\3/g')
hash=$(nix-prefetch-git --url $rep 2>&1 | grep -m1 hash | sed 's/hash is \(.*\)/\1/g')
git clone $rep $name
cd $name
version=$(git log -n 1 --pretty=format:"%ci" | sed 's/\([0-9-]\)\s.*/\1/g')
cd ../
rm -rf $name

echo "
{ vimUtils, fetchgit, stdenv, lib }:
vimUtils.buildVimPlugin {
  pname = \"$name\";
  version = \"git-$version\";
  src = fetchgit {
    url = \"$rep\";
    rev = \"$rev\";
    sha256 = \"$hash\";
  };
  meta = {
    homepage = $homepage;
    maintainers = [ lib.maintainers.leo60228 ];
  };
}
" | sed -r '/^\s*$/d' | tee "${1#*/}.nix"
