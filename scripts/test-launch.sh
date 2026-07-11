#!/usr/bin/env bash
set -euo pipefail

if ROOT_DIR="$(git rev-parse --show-toplevel 2>/dev/null)"; then
  :
else
  ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
fi

LAUNCHER="$ROOT_DIR/snap/local/bin/launch"
TMP_DIR="$(mktemp -d /tmp/gh-aw/agent/launch-test.XXXXXX)"
trap 'rm -rf "$TMP_DIR"' EXIT

SNAP_DIR="$TMP_DIR/snap dir"
COMMON_DIR="$TMP_DIR/common dir"
mkdir -p "$SNAP_DIR/bin" "$COMMON_DIR"

cat > "$SNAP_DIR/bin/halloy" <<'EOF'
#!/usr/bin/env bash
{
  printf '%s\n' "$0"
  printf '%s\n' "$XDG_CONFIG_HOME"
  printf '%s\n' "$#"
  printf '%s\n' "$1"
  printf '%s\n' "$2"
} > "$SNAP_USER_COMMON/launch.log"
EOF
chmod +x "$SNAP_DIR/bin/halloy"

SNAP="$SNAP_DIR" SNAP_USER_COMMON="$COMMON_DIR" "$LAUNCHER" --flag "two words"

mapfile -t lines < "$COMMON_DIR/launch.log"
expected=(
  "$SNAP_DIR/bin/halloy"
  "$COMMON_DIR/.config"
  "2"
  "--flag"
  "two words"
)

if [ "${#lines[@]}" -ne "${#expected[@]}" ]; then
  printf 'ERROR: expected %d lines, got %d\n' "${#expected[@]}" "${#lines[@]}" >&2
  exit 1
fi

for i in "${!expected[@]}"; do
  if [ "${lines[$i]}" != "${expected[$i]}" ]; then
    printf 'ERROR: line %d mismatch: expected %q, got %q\n' "$((i + 1))" "${expected[$i]}" "${lines[$i]}" >&2
    exit 1
  fi
done

echo 'Launcher quoting test passed'
