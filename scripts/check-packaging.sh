#!/usr/bin/env bash
set -euo pipefail

# Simple packaging smoke check for snap launcher presence and snapcraft reference.
# Exits non-zero on failure so CI can catch packaging regressions early.

# repo root assumed to be current working directory
SNAP_LAUNCHER="snap/local/bin/launch"
SNAPCRAFT_YAML="snap/snapcraft.yaml"

if [ ! -f "$SNAP_LAUNCHER" ]; then
  echo "ERROR: $SNAP_LAUNCHER not found" >&2
  exit 2
fi

if ! grep -q "command: bin/launch" "$SNAPCRAFT_YAML"; then
  echo "ERROR: $SNAPCRAFT_YAML does not reference 'command: bin/launch'" >&2
  exit 3
fi

echo "OK: packaging launcher present and referenced in $SNAPCRAFT_YAML"
exit 0
