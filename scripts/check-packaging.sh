#!/usr/bin/env bash
set -euo pipefail

# Basic packaging checks for snap:
# - snap/local exists (expected local launcher files)
# - snap/snapcraft.yaml contains an 'apps:' section

if [ ! -d snap/local ]; then
  echo "ERROR: snap/local directory not found"
  exit 2
fi

if [ ! -f snap/snapcraft.yaml ]; then
  echo "ERROR: snap/snapcraft.yaml not found"
  exit 3
fi

if ! grep -q -E '^[[:space:]]*apps:' snap/snapcraft.yaml; then
  echo "ERROR: snap/snapcraft.yaml has no 'apps:' section"
  exit 4
fi

echo "OK: packaging checks passed"
exit 0
