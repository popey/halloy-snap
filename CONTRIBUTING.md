# Contributing

Thanks for your interest in contributing to halloy-snap. This repository maintains the community snap packaging for Halloy, so most changes should stay focused on packaging, CI, metadata, and release updates.

## Before opening a PR

- Keep changes small and focused on one concern.
- Open an issue first for larger changes, new dependencies, or CI workflow changes.
- Check that `snap/snapcraft.yaml` still matches the current packaging layout.
- Include the motivation for the change and the testing you performed.

## Testing

For packaging changes, run the most relevant local checks you can and mention any checks you could not run. CI builds the snap and runs a smoke test, so PRs should include enough context to diagnose build or launch failures.

Docs-only changes do not need a snap build, but the PR should say that no runtime behavior changed.

## Review expectations

- Keep review discussion practical and respectful.
- Avoid unrelated cleanup in the same PR.
- If CI fails for infrastructure reasons, note that in the PR instead of force-pushing unrelated changes.

If you are unsure where to start, open an issue describing what you want to improve.
