#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCRIPT="$ROOT_DIR/scripts/check-packaging.sh"
WORKDIR="$(mktemp -d /tmp/gh-aw/agent/check-packaging.XXXXXX)"
trap 'rm -rf "$WORKDIR"' EXIT

make_fixture() {
  local name="$1"
  local command_line="$2"
  local launcher_path="$3"
  local executable="$4"

  local fixture="$WORKDIR/$name"
  mkdir -p "$fixture/snap/local/$(dirname "$launcher_path")"

  cat >"$fixture/snap/snapcraft.yaml" <<YAML
name: halloy
apps:
  halloy:
    command: $command_line
YAML

  cat >"$fixture/snap/local/$launcher_path" <<'EOF'
#!/usr/bin/env bash
exit 0
EOF

  if [ "$executable" = "yes" ]; then
    chmod +x "$fixture/snap/local/$launcher_path"
  fi

  printf '%s' "$fixture"
}

success_fixture="$(make_fixture success 'bin/launch --windowed' 'bin/launch' yes)"
success_output="$(ROOT_DIR="$success_fixture" bash "$SCRIPT")"
case "$success_output" in
  *"OK: bin/launch is present and executable"*) : ;;
  *)
    echo "expected success output to mention the launcher"
    printf '%s\n' "$success_output"
    exit 1
    ;;
esac
case "$success_output" in
  *"Packaging checks passed"*) : ;;
  *)
    echo "expected success output to end cleanly"
    printf '%s\n' "$success_output"
    exit 1
    ;;
esac

absolute_fixture="$(make_fixture absolute '/snap/bin/halloy --windowed' 'bin/launch' yes)"
absolute_output="$(ROOT_DIR="$absolute_fixture" bash "$SCRIPT")"
case "$absolute_output" in
  *"Skipping absolute command path: /snap/bin/halloy"*) : ;;
  *)
    echo "expected absolute command paths to be skipped"
    printf '%s\n' "$absolute_output"
    exit 1
    ;;
esac

missing_fixture="$WORKDIR/missing"
mkdir -p "$missing_fixture/snap/local/bin"
cat >"$missing_fixture/snap/snapcraft.yaml" <<'YAML'
name: halloy
apps:
  halloy:
    command: bin/missing --windowed
YAML

failure_output="$WORKDIR/missing.out"
if ROOT_DIR="$missing_fixture" bash "$SCRIPT" >"$failure_output" 2>&1; then
  echo "expected missing launcher fixture to fail"
  cat "$failure_output"
  exit 1
fi
if ! grep -q "ERROR: launcher not found: $missing_fixture/snap/local/bin/missing" "$failure_output"; then
  echo "expected missing launcher error"
  cat "$failure_output"
  exit 1
fi

echo "Packaging check tests passed"
