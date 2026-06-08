# halloy-snap

[![halloy](https://github.com/popey/halloy-snap/actions/workflows/test-snap-can-build.yml/badge.svg)](https://github.com/popey/halloy-snap/actions)
[![halloy](https://snapcraft.io/halloy/badge.svg)](https://snapcraft.io/halloy)
[![halloy](https://snapcraft.io/halloy/trending.svg?name=0)](https://snapcraft.io/halloy)

## halloy

halloy is a beautiful, modern IRC client written in Rust.

This snap is a community-maintained unofficial build of halloy. 

[![Get it from the Snap Store](https://snapcraft.io/static/images/badges/en/snap-store-black.svg)](https://snapcraft.io/halloy)

## Developer notes

If you update agentic workflows or their frontmatter, recompile the workflow and commit the generated lock file to avoid "compiled lock file out of sync" failures:

```bash
gh aw compile
```

After running `gh aw compile`, commit and push the updated `.lock.yml` file alongside the workflow changes.

