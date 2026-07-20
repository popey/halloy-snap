#!/usr/bin/env bash
set -euo pipefail

launcher="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/snap/local/bin/launch"

bash -n "$launcher"
grep -Fx 'exec "$SNAP/bin/halloy" "$@"' "$launcher"

echo "Launcher quoting check passed"
