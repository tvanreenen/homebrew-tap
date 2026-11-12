# Personal Homebrew compatibility tap

Frame, Key (including its alpha and beta channels), and xkcdpass now use the existing [TVR Works tap](https://github.com/tvr-works/homebrew-tap). This repository remains available for its `tap_migrations.json` forwarding entries and existing users. Keep it installed while legacy tokens or receipts depend on those entries.

## Existing installations

Update Homebrew, add the destination tap, and use its fully qualified package names:

```sh
brew update
brew tap tvr-works/tap
brew upgrade --cask tvr-works/tap/frame
brew upgrade --cask tvr-works/tap/key
brew upgrade tvr-works/tap/xkcdpass
```

Use only the commands for packages you have installed. For Key Preview, substitute `key@alpha` or `key@beta`; the Preview channels share one app identity, so select one channel at a time. On Homebrew versions that request tap trust, approve the specific destination package when prompted, for example `brew trust --cask tvr-works/tap/frame`.

Frame retains the `frame` token, `com.frame.app` bundle identifier, existing app/CLI layout, signing team, configuration paths, and published `v3.2.0` archive/checksum. Existing download URLs redirect to the transferred source repository. Same-version cask moves can keep the legacy installed receipt until an actual installation; a future genuine upgrade or an explicit `brew reinstall --cask tvr-works/tap/frame` can refresh it. No uninstall or configuration/data deletion is part of these migration instructions. Do not replace historical release bytes or invent a version bump to move ownership.

The destination Frame cask uses standard Homebrew quarantine handling and does not copy this tap's former quarantine-removal workaround. The current preserved release is not qualified as notarized. Real-device first-launch/Gatekeeper acceptance, Accessibility/login continuity, and a later genuinely newer-version upgrade remain separate qualifications; source ownership and signature continuity do not by themselves prove those behaviors. Key app/helper/vault identities and the xkcdpass package identity also remain unchanged.

Fresh installations use `brew install --cask tvr-works/tap/frame`, the corresponding organization Key cask, or `brew install tvr-works/tap/xkcdpass`.

## Publication has moved

Source projects still own their releases. The organization tap owns downloaded-release verification, package rendering, Homebrew checks, and update PRs. Dispatch the manually operated `publish-package.yml` in `tvr-works/homebrew-tap` with the package and its published v-prefixed version. Source projects use the operator's existing GitHub CLI login and do not hold a tap credential.

The compatibility workflow and preparation script in this repository reject old `frame`, `key`, and `xkcdpass` publication requests before release downloads or proposals. The workflow has no repository token permissions and performs no checkout. Existing Key/key@alpha/key@beta/xkcdpass forwarding entries are retained alongside Frame's new entry.

The required checks retain tap syntax/audit validation and the migration-contract suite. With no package definitions left, the audit job validates the compatibility tap's syntax; the separate contract checks the exact forwarding map, absence of moved packages, and rejection of retired publishers without GitHub access. Integrate destination Frame support and the source dispatch route before merging this final forwarding change. Never remove this compatibility repository as a migration shortcut.
