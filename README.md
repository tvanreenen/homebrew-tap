# Homebrew tap

This tap contains Frame and xkcdpass. Key is maintained in [tvr-works/homebrew-tap](https://github.com/tvr-works/homebrew-tap).

## Key installations

Key’s Stable, alpha, and beta casks have moved to `tvr-works/tap`. The `tap_migrations.json` entries redirect the old tokens to the organization tap. Update Homebrew, add the new tap, and use its fully qualified cask for upgrades:

```sh
brew update
brew tap tvr-works/tap
brew upgrade --cask tvr-works/tap/key
```

For Preview, substitute `key@alpha` or `key@beta`. New installations use `brew install --cask tvr-works/tap/key`. Keep this personal tap if you also use Frame or xkcdpass. No Key app, helper, or vault identity changes are involved.

Key release publication now targets the organization tap. Old `package=key` dispatches to this repository are rejected; the remaining publisher supports Frame and xkcdpass.

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

The `xkcdpass` formula installs the published `darwin/arm64` archive on macOS 13 Ventura or later and the published `linux/amd64` archive on x86-64 Linux. Its publication path verifies both archives and checksums before proposing an update.
