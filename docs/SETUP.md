# Codex Cloud setup

This repository contains reusable Ubuntu Linux x86_64 setup scripts for Flutter/Dart, Android SDK/JDK 17, PHP/Composer, Node.js LTS/npm, and Python/pip/venv.

## Usage

1. Connect this repository to a Codex Cloud Environment.
2. Configure the Environment setup script to run `bash .codex/setup.sh`.
3. Allow downloads during setup where supported.
4. Launch a new task and run `source "$HOME/.codex-dev-env" && bash scripts/verify.sh`.

## Reusing for another project

This repository does **not** automatically configure other repositories. Copy the scripts into the target project or fetch them from a reviewed, pinned commit. Configure the target project's Codex Environment accordingly.

## Flags

Defaults: `INSTALL_FLUTTER=1`, `INSTALL_ANDROID=1`, `INSTALL_PHP=1`, `INSTALL_NODE=1`, `INSTALL_PYTHON=1`. Set a flag to 0 to skip it. Android defaults: `ANDROID_API=35`, `ANDROID_BUILD_TOOLS=35.0.0`.

## Limitations and security

Requires passwordless sudo, network access during setup, and sufficient disk space. Official download locations may change. Toolchain versions and archives are not cryptographically pinned: pin versions and verify checksums before production use. Flutter doctor may warn about optional desktop components. Linux does not build iOS apps, and Android emulator availability is not guaranteed. Never commit tokens, credentials, or signing keys.
