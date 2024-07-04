#!/usr/bin/env nix-shell
#! nix-shell -i bash -p curl jq coreutils nix-prefetch-github gnused bundix prefetch-yarn-deps

set -e

cd "$(dirname "$0")"

commit="$(curl -SsL 'https://api.github.com/repos/BlaseballCrabs/mastodon/branches/crabstodon')"
rev="$(jq -r '.commit.sha' <<<"$commit")"
date="$(jq -r '.commit.commit.committer.date' <<<"$commit")"
date="$(date --date="$date" --iso-8601=date)"
echo "current commit is $rev, prefetching..."

hash="$(nix-prefetch-github BlaseballCrabs mastodon --rev "$rev" | jq -r '.hash')"

sed -i -Ee "s|^( *rev = )\".*\";|\\1\"$rev\";|g;" ./source.nix
sed -i -Ee "s|^( *hash = )\".*\";|\\1\"$hash\";|g;" ./source.nix
sed -i -Ee "s|^( *version = )\".*\";|\\1\"unstable-$date\";|g;" ./source.nix

echo "building source"
srcdir="$(nix-build --no-out-link -E '(import <nixpkgs> {}).callPackage ./source.nix {}')"

echo "creating gemset"
rm -f gemset.nix
bundix --lockfile $srcdir/Gemfile.lock --gemfile $srcdir/Gemfile
echo "" >> gemset.nix

# TODO: find a way to automate this
# echo "creating yarn hash"
# hash="$(prefetch-yarn-deps $srcdir/yarn.lock)"
# hash="$(nix hash --to-sri --type sha256 "$hash")"
# sed -i -Ee "s|^( *yarnHash = )\".*\";|\\1\"$hash\";|g;' ./source.nix
