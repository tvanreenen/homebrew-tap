cask "key@alpha" do
  version "v0.2.0-alpha.3"
  sha256 "30f8ea9064bc3b3ef8c8e610c47bff84046fc2c1f4c95c33acd303469ecb0060"

  url "https://github.com/tvanreenen/key/releases/download/v0.2.0-alpha.3/Key-v0.2.0-alpha.3.zip"
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
