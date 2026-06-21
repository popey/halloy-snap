#!/usr/bin/env sh
set -e
# simple packaging check
missing=0
if [ ! -f snap/snapcraft.yaml ]; then
  echo "ERROR: snap/snapcraft.yaml not found"
  exit 2
fi
# Check for local launcher directory
if [ -d snap/local ] || [ -d snap/local/bin ]; then
  echo "Found snap/local directory"
else
  echo "WARN: snap/local directory not found — packaging may fail"
  missing=1
fi
# Heuristic: check if snapcraft.yaml references 'local/' paths
if grep -q "local/" snap/snapcraft.yaml; then
  echo "snapcraft.yaml references local/ files"
else
  echo "WARN: snapcraft.yaml does not reference local/ files"
fi
if [ $missing -eq 1 ]; then
  exit 1
fi

echo "Packaging check passed"
