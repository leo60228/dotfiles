export PATH="$PATH:$HOME/bin/:$HOME/.cargo/bin"
export ANDROID_SDK_PATH="$(dirname $(readlink $(readlink $(which android))))/.."
export ANDROID_NDK_PATH="$(dirname $(readlink $(readlink $(which ndk-build))))/.."

export NIX_REMOTE=daemon
