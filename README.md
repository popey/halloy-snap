# halloy-snap

[![halloy](https://github.com/popey/halloy-snap/actions/workflows/test-snap-can-build.yml/badge.svg)](https://github.com/popey/halloy-snap/actions)
[![halloy](https://snapcraft.io/halloy/badge.svg)](https://snapcraft.io/halloy)
[![halloy](https://snapcraft.io/halloy/trending.svg?name=0)](https://snapcraft.io/halloy)

## halloy

halloy is a beautiful, modern IRC client written in Rust.

This snap is a community-maintained unofficial build of halloy. 

[![Get it from the Snap Store](https://snapcraft.io/static/images/badges/en/snap-store-black.svg)](https://snapcraft.io/halloy)

## Developer notes

If a Repo Assist workflow reports a "compiled lock file out of sync" error, recompile the workflows and commit the generated lock file before rerunning the workflow:

```
# Recompile the workflows
gh aw compile

# Stage and commit the updated compiled lock file(s)
git add .github/workflows/*.lock.yml
git commit -m "docs: recompile workflow lock files"

git push
```
