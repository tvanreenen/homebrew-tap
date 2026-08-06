cask "key@alpha" do
  version "v0.2.0-alpha.6"
  sha256 "20a907a86f75018452005bb6530dd8bea3dffe86b349a9e19272bb5e7428726f"

  url "https://github.com/tvanreenen/key/releases/download/v0.2.0-alpha.6/Key-v0.2.0-alpha.6.zip"
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
