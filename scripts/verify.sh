#!/usr/bin/env bash
set -uo pipefail
[ -f "$HOME/.codex-dev-env" ] && . "$HOME/.codex-dev-env"
status=0
for tool in git php composer node npm python3 flutter java sdkmanager; do
  if command -v "$tool" >/dev/null 2>&1; then
    echo "[OK] $tool: $(command -v "$tool")"
  else
    echo "[INFO] $tool not found (may be disabled by INSTALL_* flag)"
  fi
done
if command -v flutter >/dev/null 2>&1; then flutter doctor -v || status=1; fi
exit "$status"
