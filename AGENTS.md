# Codex Cloud development instructions

This repository holds reusable Codex Cloud setup scripts. It is not an application repository.

## Bootstrap
- Run `bash .codex/setup.sh` in the Codex Cloud Environment setup script.
- Toolchains are installed in the user's home directory, not committed to Git.
- Load environment for subsequent tasks with `source "$HOME/.codex-dev-env"`.
- Run `bash scripts/verify.sh` for diagnostics. Optional Flutter doctor warnings (Chrome, Android Studio, Linux desktop) may not block Android CLI builds.

## Working on application repositories
- Detect project versions from `pubspec.yaml`, Gradle wrapper, `composer.json`, `package.json`, `.nvmrc`, `pyproject.toml`, and `.python-version`.
- Match project requirements before changing Flutter, Gradle, Java, or Android API versions.
- Flutter: `flutter pub get`, `flutter analyze`, `flutter test`, then `flutter build apk --debug` if Android target exists.
- PHP: `composer install`, then configured PHPUnit/Pest tests.
- Node: prefer `npm ci` with package-lock; otherwise follow the lockfile's package manager.
- Python: create `.venv`, install dependencies, and run configured tests.
- Never commit secrets, `.env` files, SDK binaries, caches, build output, or credentials.
- Report skipped, failed, or unverified commands; never claim an APK build succeeded without verifying it.
- Do not change application behavior just to make environment checks pass.
