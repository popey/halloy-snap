#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
tmp_root="$(mktemp -d /tmp/gh-aw/agent/check-packaging-desktop.XXXXXX)"

cleanup() {
  rm -rf "$tmp_root"
}

trap cleanup EXIT

mkdir -p "$tmp_root/scripts" "$tmp_root/snap/local/bin" "$tmp_root/snap/gui"
cp "$repo_root/scripts/check-packaging.sh" "$tmp_root/scripts/check-packaging.sh"
cp "$repo_root/snap/snapcraft.yaml" "$tmp_root/snap/snapcraft.yaml"
cp "$repo_root/snap/local/bin/launch" "$tmp_root/snap/local/bin/launch"
cp "$repo_root/snap/gui/halloy.desktop" "$tmp_root/snap/gui/halloy.desktop"
cp "$repo_root/snap/gui/org.squidowl.halloy.png" "$tmp_root/snap/gui/org.squidowl.halloy.png"

(
  cd "$tmp_root"
  bash scripts/check-packaging.sh
)

sed -i 's/^Exec=halloy$/Exec=broken-launcher/' "$tmp_root/snap/gui/halloy.desktop"

if (
  cd "$tmp_root"
  bash scripts/check-packaging.sh
); then
  echo "ERROR: expected packaging check to fail when the desktop Exec entry changes" >&2
  exit 1
fi
