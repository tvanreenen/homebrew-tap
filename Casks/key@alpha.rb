cask "key@alpha" do
  version "v0.2.0-alpha.4"
  sha256 "fc964ae02abccddacdcc0faac840c35f492e4214ecd8971118b0bcb2086d4b14"

  url "https://github.com/tvanreenen/key/releases/download/v0.2.0-alpha.4/Key-v0.2.0-alpha.4.zip"
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
