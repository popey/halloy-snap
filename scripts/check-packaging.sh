#!/bin/sh
set -e
missing=0
if [ ! -d snap/local ]; then
  echo "ERROR: snap/local missing"
  missing=1
fi
if [ ! -f snap/snapcraft.yaml ]; then
  echo "ERROR: snap/snapcraft.yaml missing"
  missing=1
fi
if [ -d snap/local/bin ]; then
  if [ -z "$(ls -A snap/local/bin 2>/dev/null)" ]; then
    echo "ERROR: snap/local/bin is empty"
    missing=1
  fi
else
  echo "ERROR: snap/local/bin missing"
  missing=1
fi
if grep -qE "local/|snap/local" snap/snapcraft.yaml 2>/dev/null; then
  echo "OK: snapcraft.yaml references local/"
else
  if grep -q "command:" snap/snapcraft.yaml 2>/dev/null; then
    echo "WARN: snapcraft.yaml has 'command:' but no explicit 'local/' reference"
  else
    echo "WARN: snapcraft.yaml does not reference local/ or 'command:'"
  fi
fi
exit $missing
