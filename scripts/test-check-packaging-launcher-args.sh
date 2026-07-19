#!/usr/bin/env bash
set -euo pipefail

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

mkdir -p "$tmpdir/scripts" "$tmpdir/snap/local/bin" "$tmpdir/snap"
cp /home/runner/work/halloy-snap/halloy-snap/scripts/check-packaging.sh "$tmpdir/scripts/check-packaging.sh"
cat > "$tmpdir/snap/snapcraft.yaml" <<'YAML'
apps:
  halloy:
    command: bin/launch --windowed
YAML
cat > "$tmpdir/snap/local/bin/launch" <<'SH'
#!/usr/bin/env bash
exit 0
SH
chmod +x "$tmpdir/snap/local/bin/launch"
chmod +x "$tmpdir/scripts/check-packaging.sh"

(cd "$tmpdir" && ./scripts/check-packaging.sh) >"$tmpdir/output.txt"

grep -F "Packaging checks passed" "$tmpdir/output.txt" >/dev/null
