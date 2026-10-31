#!/usr/bin/env bash
set -Eeuo pipefail
export DEBIAN_FRONTEND=noninteractive
INSTALL_FLUTTER="${INSTALL_FLUTTER:-1}"
INSTALL_ANDROID="${INSTALL_ANDROID:-1}"
INSTALL_PHP="${INSTALL_PHP:-1}"
INSTALL_NODE="${INSTALL_NODE:-1}"
INSTALL_PYTHON="${INSTALL_PYTHON:-1}"
ANDROID_API="${ANDROID_API:-35}"
ANDROID_BUILD_TOOLS="${ANDROID_BUILD_TOOLS:-35.0.0}"
FLUTTER_CHANNEL="${FLUTTER_CHANNEL:-stable}"
ANDROID_CMDLINE_TOOLS_URL="${ANDROID_CMDLINE_TOOLS_URL:-https://dl.google.com/android/repository/commandlinetools-linux-13114758_latest.zip}"
if [ "$(uname -s)" != Linux ] || [ "$(uname -m)" != x86_64 ]; then echo 'Requires Linux x86_64'; exit 1; fi
sudo -n true || { echo 'Passwordless sudo is required'; exit 1; }
sudo apt-get update
sudo apt-get install -y ca-certificates curl git unzip zip xz-utils jq build-essential libglu1-mesa
if [ "$INSTALL_PYTHON" = 1 ]; then sudo apt-get install -y python3 python3-pip python3-venv; fi
if [ "$INSTALL_PHP" = 1 ]; then sudo apt-get install -y php-cli php-mbstring php-xml php-curl php-zip php-sqlite3 composer; fi
if [ "$INSTALL_NODE" = 1 ]; then
  export NVM_DIR="$HOME/.nvm"
  if [ ! -s "$NVM_DIR/nvm.sh" ]; then curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash; fi
  . "$NVM_DIR/nvm.sh"
  nvm install --lts
  nvm alias default 'lts/*'
fi
if [ "$INSTALL_FLUTTER" = 1 ]; then
  if [ ! -d "$HOME/flutter/.git" ]; then git clone --depth 1 --branch "$FLUTTER_CHANNEL" https://github.com/flutter/flutter.git "$HOME/flutter"; fi
  export PATH="$HOME/flutter/bin:$PATH"
  flutter config --no-analytics
  flutter --version
fi
if [ "$INSTALL_ANDROID" = 1 ]; then
  sudo apt-get install -y openjdk-17-jdk
  export ANDROID_HOME="$HOME/android-sdk"
  export ANDROID_SDK_ROOT="$ANDROID_HOME"
  mkdir -p "$ANDROID_HOME/cmdline-tools"
  if [ ! -x "$ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager" ]; then
    tmpdir="$(mktemp -d)"
    curl -fL --retry 3 "$ANDROID_CMDLINE_TOOLS_URL" -o "$tmpdir/cmdline-tools.zip"
    unzip -q "$tmpdir/cmdline-tools.zip" -d "$tmpdir"
    mv "$tmpdir/cmdline-tools" "$ANDROID_HOME/cmdline-tools/latest"
    rm -rf "$tmpdir"
  fi
  export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH"
  set +o pipefail
  yes | sdkmanager --sdk_root="$ANDROID_HOME" --licenses >/dev/null
  set -o pipefail
  sdkmanager --sdk_root="$ANDROID_HOME" 'platform-tools' "platforms;android-$ANDROID_API" "build-tools;$ANDROID_BUILD_TOOLS"
  if [ "$INSTALL_FLUTTER" = 1 ]; then flutter config --android-sdk "$ANDROID_HOME"; fi
fi
cat > "$HOME/.codex-dev-env" <<'ENV'
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
export FLUTTER_HOME="$HOME/flutter"
export ANDROID_HOME="$HOME/android-sdk"
export ANDROID_SDK_ROOT="$ANDROID_HOME"
export PATH="$FLUTTER_HOME/bin:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH"
ENV
if ! grep -Fq '.codex-dev-env' "$HOME/.bashrc" 2>/dev/null; then printf '\n[ -f "$HOME/.codex-dev-env" ] && . "$HOME/.codex-dev-env"\n' >> "$HOME/.bashrc"; fi
if ! grep -Fq '.codex-dev-env' "$HOME/.profile" 2>/dev/null; then printf '\n[ -f "$HOME/.codex-dev-env" ] && . "$HOME/.codex-dev-env"\n' >> "$HOME/.profile"; fi
. "$HOME/.codex-dev-env"
"$(dirname "$0")/../scripts/verify.sh"
