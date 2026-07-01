#!/usr/bin/env bash
set -euo pipefail

if [ -z "${ROOT_DIR:-}" ]; then
  if ROOT_DIR="$(git rev-parse --show-toplevel 2>/dev/null)"; then
    :
  else
    ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
  fi
fi
SNAP_LOCAL="$ROOT_DIR/snap/local"
SNAPCRAFT_YAML="$ROOT_DIR/snap/snapcraft.yaml"

failed=0

if [ ! -d "$SNAP_LOCAL" ]; then
  echo "ERROR: snap/local directory not found" >&2
  failed=1
fi

if [ ! -f "$SNAPCRAFT_YAML" ]; then
  echo "ERROR: snap/snapcraft.yaml not found" >&2
  failed=1
fi

if [ "$failed" -ne 0 ]; then
  exit 1
fi

mapfile -t commands < <(
  awk '
    /^[[:space:]]*command:[[:space:]]*/ {
      sub(/^[[:space:]]*command:[[:space:]]*/, "")
      gsub(/^["'\'']|["'\'']$/, "")
      print
    }
  ' "$SNAPCRAFT_YAML"
)

if [ "${#commands[@]}" -eq 0 ]; then
  echo "ERROR: no app command entries found in snap/snapcraft.yaml" >&2
  exit 1
fi

for command in "${commands[@]}"; do
  read -r launcher _ <<<"$command"

  if [[ "$launcher" = /* ]]; then
    echo "Skipping absolute command path: $launcher"
    continue
  fi

  launcher_path="$SNAP_LOCAL/$launcher"

  if [ ! -f "$launcher_path" ]; then
    echo "ERROR: launcher not found: $launcher_path" >&2
    failed=1
    continue
  fi

  if [ ! -x "$launcher_path" ]; then
    echo "ERROR: launcher is not executable: $launcher_path" >&2
    failed=1
    continue
  fi

  echo "OK: $launcher is present and executable"
done

if [ "$failed" -ne 0 ]; then
  exit 1
fi

echo "Packaging checks passed"
