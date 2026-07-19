#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

mkdir -p "$tmpdir/root/snap/local/bin" "$tmpdir/root/snap"
cat > "$tmpdir/root/snap/snapcraft.yaml" <<'YAML'
apps:
  halloy:
    command: bin/launch
YAML
cat > "$tmpdir/root/snap/local/bin/launch" <<'SH'
#!/usr/bin/env bash
exit 0
SH
chmod +x "$tmpdir/root/snap/local/bin/launch"

ROOT_DIR="$tmpdir/root" "$repo_root/scripts/check-packaging.sh" >"$tmpdir/output.txt"

grep -F "Packaging checks passed" "$tmpdir/output.txt" >/dev/null
