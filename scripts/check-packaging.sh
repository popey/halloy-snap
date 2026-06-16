#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
SNAP_YAML="$ROOT_DIR/snap/snapcraft.yaml"
LOCAL_DIR="$ROOT_DIR/snap/local"

echo "Checking packaging for halloy snap..."

if [ ! -f "$SNAP_YAML" ]; then
  echo "ERROR: $SNAP_YAML not found." >&2
  exit 2
fi

if [ ! -d "$LOCAL_DIR" ]; then
  echo "ERROR: $LOCAL_DIR not found. Expected local launcher files under snap/local/" >&2
  exit 3
fi

# Ensure there is at least one executable in snap/local
num_execs=$(find "$LOCAL_DIR" -maxdepth 2 -type f -executable | wc -l)
if [ "$num_execs" -lt 1 ]; then
  echo "ERROR: No executable files found under $LOCAL_DIR" >&2
  exit 4
fi

# Basic check that snapcraft.yaml references a local file path (heuristic)
if grep -q "local" "$SNAP_YAML" || grep -q "snap/local" "$SNAP_YAML"; then
  echo "snapcraft.yaml references local files — good." 
else
  echo "WARNING: snapcraft.yaml does not appear to reference snap/local paths. Please verify launchers in snapcraft.yaml." >&2
fi

echo "Packaging check passed (found $num_execs executable(s) in snap/local)." 
exit 0
