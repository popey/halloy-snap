#!/usr/bin/env bash
set -euo pipefail

tmp_dir="$(mktemp -d /tmp/gh-aw/agent/check-packaging-syntax.XXXXXX)"
cleanup() {
  rm -rf "$tmp_dir"
}
trap cleanup EXIT

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p "$tmp_dir/snap/local/bin"
cp "$script_dir/../snap/snapcraft.yaml" "$tmp_dir/snap/snapcraft.yaml"
cp "$script_dir/check-packaging.sh" "$tmp_dir/check-packaging.sh"
cp "$script_dir/../snap/local/bin/launch" "$tmp_dir/snap/local/bin/launch"

python3 - <<'PY' "$tmp_dir/check-packaging.sh"
from pathlib import Path
import sys

path = Path(sys.argv[1])
source = path.read_text()
old = '''if ROOT_DIR="$(git rev-parse --show-toplevel 2>/dev/null)"; then
  :
else
  ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
fi'''
path.write_text(source.replace(old, 'ROOT_DIR="$(pwd)"'))
PY

chmod +x "$tmp_dir/check-packaging.sh"
( cd "$tmp_dir" && ./check-packaging.sh )

cat > "$tmp_dir/snap/local/bin/launch" <<'EOF'
#!/bin/bash
echo broken
if then
EOF
chmod +x "$tmp_dir/snap/local/bin/launch"

if ( cd "$tmp_dir" && ./check-packaging.sh ); then
  echo "ERROR: syntax check should fail for broken launcher" >&2
  exit 1
fi

echo "Packaging syntax regression checks passed"
