# Homebrew tap

## Publishing package updates

Each project publishes and verifies its GitHub release before Homebrew changes. After this workflow is present on `main`, open **Publish package update** in this repository's Actions tab, choose `main`, select the package, and enter its v-prefixed version. Project release commands dispatch the same workflow through the operator's existing GitHub CLI login; they do not hold a tap credential.

```sh
gh workflow run publish-package.yml \
  --repo tvanreenen/homebrew-tap \
  --ref main \
  -f package=xkcdpass \
  -f version=v0.1.1
```

The workflow accepts only the checked-in package choices. Runs are queued per package. It verifies the published release and checksum, prepares and formats exactly one formula or cask change, runs the relevant Homebrew checks with read-only permissions, and then uses this repository's `GITHUB_TOKEN` to open a pull request containing the verified patch. No source-repository credential is required.

If release verification finds missing, extra, or inconsistent assets, publish a new source version instead of replacing release assets. If a Homebrew or proposal step fails, fix the tap on `main` and dispatch the same version again. An exact update already on `main` succeeds without a pull request, and an existing open pull request is reused. If an automation branch exists without an open pull request, inspect or remove that branch before retrying.

The repository setting **Allow GitHub Actions to create and approve pull requests** must be enabled for the final proposal job. Keep the default `GITHUB_TOKEN` permission read-only; the workflow grants write access only to that job. GitHub holds checks on a pull request created by `GITHUB_TOKEN` for approval; use **Approve workflows to run** in the pull request before merging.
