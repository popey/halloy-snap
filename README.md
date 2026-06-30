# halloy-snap

[![halloy](https://github.com/popey/halloy-snap/actions/workflows/test-snap-can-build.yml/badge.svg)](https://github.com/popey/halloy-snap/actions)
[![halloy](https://snapcraft.io/halloy/badge.svg)](https://snapcraft.io/halloy)
[![halloy](https://snapcraft.io/halloy/trending.svg?name=0)](https://snapcraft.io/halloy)

## halloy

halloy is a beautiful, modern IRC client written in Rust.

This snap is a community-maintained unofficial build of halloy. 

[![Get it from the Snap Store](https://snapcraft.io/static/images/badges/en/snap-store-black.svg)](https://snapcraft.io/halloy)

## Developer notes

If you edit `.github/workflows/repo-assist.md`, recompile the generated lock file before opening a pull request:

```bash
gh aw compile
```

Commit the updated `.github/workflows/repo-assist.lock.yml` with the workflow change.
