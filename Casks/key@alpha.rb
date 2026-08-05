cask "key@alpha" do
  version "v0.2.0-alpha.5"
  sha256 "28ffeea39dd94ae73b4fe79c2808d0f3d7d554af606b19be84dfe3856e9795a2"

  url "https://github.com/tvanreenen/key/releases/download/v0.2.0-alpha.5/Key-v0.2.0-alpha.5.zip"
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
