#!/usr/bin/env bash
set -euo pipefail

if ROOT_DIR="$(git rev-parse --show-toplevel 2>/dev/null)"; then
  :
else
  ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
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

mapfile -t app_commands < <(
  awk '
    /^apps:[[:space:]]*$/ {
      in_apps=1
      current_app=""
      next
    }

    in_apps && /^  [^[:space:]][^:]*:[[:space:]]*$/ {
      current_app=$1
      sub(/:$/, "", current_app)
      next
    }

    in_apps && /^[[:space:]]*command:[[:space:]]*/ {
      if (current_app != "") {
        sub(/^[[:space:]]*command:[[:space:]]*/, "")
        gsub(/^"|"$/, "")
        print current_app "|" $0
      }
    }
  ' "$SNAPCRAFT_YAML"
)

if [ "${#app_commands[@]}" -eq 0 ]; then
  echo "ERROR: no app command entries found in snap/snapcraft.yaml" >&2
  exit 1
fi

for app_command in "${app_commands[@]}"; do
  app_name="${app_command%%|*}"
  command="${app_command#*|}"
  launcher="${command##* }"

  if [[ "$launcher" = /* ]]; then
    echo "Skipping absolute command path for $app_name: $launcher"
    continue
  fi

  launcher_path="$SNAP_LOCAL/$launcher"

  if [ ! -f "$launcher_path" ]; then
    echo "ERROR: launcher not found for $app_name: $launcher_path" >&2
    failed=1
    continue
  fi

  if [ ! -x "$launcher_path" ]; then
    echo "ERROR: launcher is not executable for $app_name: $launcher_path" >&2
    failed=1
    continue
  fi

  echo "OK: $app_name -> $launcher is present and executable"
done

if [ "$failed" -ne 0 ]; then
  exit 1
fi

echo "Packaging checks passed"
