#!/usr/bin/env nix-shell
#!nix-shell -i bash -p jq phpPackages.composer nix-update gnused

ext=$1
if [ -z "$ext" ]; then
    echo "I need an extension"
    exit 1
fi

set -ex
curdir=$PWD

details=$(nix-instantiate --eval --strict --json get-composer-ext-info.nix --argstr extname $ext)
echo $details | jq

composerLock=$(echo $details | jq -r .composerLock)
gitRepoUrl=$(echo $details | jq -r .gitRepoUrl)
currentRev=$(echo $details | jq -r .currentRev)
#fileWithSrc=$(echo $details | jq -r .fileWithSrc)
fileWithSrc=$curdir/default.nix
preferredBranch=$(echo $details | jq -r .preferredBranch)

tmpdir=$(mktemp -d --suffix=-composer-lock-updater)
cd $tmpdir
git clone --recursive --branch "$preferredBranch" --depth 1 "$gitRepoUrl" $ext
cd $ext
newRev=$(git rev-parse HEAD)
if [ $currentRev = $newRev ]; then
    set +x
    echo "$ext is already updated ($currentRev)"
    cd $curdir
    rm -rf $tmpdir
    exit 0
fi
composer update --no-dev --no-install
cp composer.lock $composerLock
cd $curdir
rm -rf $tmpdir

sed -i -e "s/$currentRev/$newRev/g" $fileWithSrc
nix-update --override-filename=$fileWithSrc --version=skip $ext
