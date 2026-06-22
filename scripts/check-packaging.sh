#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR=$(git rev-parse --show-toplevel 2>/dev/null || printf "%s" "$(cd "$(dirname "$0")/.." && pwd)")
SNAP_LOCAL="$ROOT_DIR/snap/local"
SNAP_YAML="$ROOT_DIR/snap/snapcraft.yaml"

missing=0

printf "Checking for %s\n" "$SNAP_LOCAL"
if [ ! -d "$SNAP_LOCAL" ]; then
  printf "ERROR: %s not found\n" "$SNAP_LOCAL"
  missing=1
fi

if [ ! -f "$SNAP_YAML" ]; then
  printf "ERROR: snapcraft.yaml not found at %s\n" "$SNAP_YAML"
  missing=1
else
  printf "Inspecting commands in %s\n" "$SNAP_YAML"
  # Find lines like 'command: bin/launch' and extract the path
  mapfile -t cmds < <(grep -E "^\s*command:" "$SNAP_YAML" | sed -E "s/^\s*command:\s*//" | tr -d '"')
  if [ ${#cmds[@]} -eq 0 ]; then
    printf "WARN: no 'command:' entries found in snapcraft.yaml\n"
  fi
  for cmd in "${cmds[@]:-}"; do
    # Normalize potential environment wrappers (take last token)
    launcher=$(printf "%s" "$cmd" | awk '{print $NF}')
    # If launcher is a relative path like bin/launch, resolve under snap/local
    path="$SNAP_LOCAL/$launcher"
    if [ -f "$path" ] && [ -x "$path" ]; then
      printf "OK: Launcher %s exists and is executable\n" "$path"
    elif [ -f "$path" ]; then
      printf "WARN: Launcher %s exists but not executable\n" "$path"
      missing=1
    else
      printf "ERROR: Launcher %s not found\n" "$path"
      missing=1
    fi
  done
fi

if [ "$missing" -eq 0 ]; then
  printf "Packaging check: PASSED\n"
  exit 0
else
  printf "Packaging check: FAILED\n"
  exit 2
fi
