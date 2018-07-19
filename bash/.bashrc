export PATH="$HOME/.bin/:$PATH:$HOME/.cargo/bin"
export ANDROID_SDK_PATH="$(dirname $(readlink $(readlink $(which android))))/.."
export ANDROID_NDK_PATH="$(dirname $(readlink $(readlink $(which ndk-build))))/.."

export NIX_REMOTE=daemon
source /home/leo60228/.git-subrepo/.rc
