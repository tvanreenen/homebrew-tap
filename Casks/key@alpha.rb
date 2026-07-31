cask "key@alpha" do
  version "v0.2.0-alpha.2"
  sha256 "72c69f63d216a360afb2e0647e6abc9d7e1b3e85b2b93fb1adf502c35cfeb602"

  url "https://github.com/tvanreenen/key/releases/download/v0.2.0-alpha.2/Key-v0.2.0-alpha.2.zip"
  name "key"
  desc "File-based secret manager with native authentication"
  homepage "https://github.com/tvanreenen/key"

  conflicts_with cask: ["key", "key@beta", "key@rc"]
  depends_on :macos

  app "Key.app"
  binary "#{appdir}/Key.app/Contents/MacOS/key", target: "key"
  zsh_completion "completions/_key"

  caveats <<~EOS
    Open Key.app once after install so it can register Key Agent with macOS before you use the key CLI.
  EOS
end
