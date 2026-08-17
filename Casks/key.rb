cask "key" do
  version "v0.2.0"
  sha256 "e70065fdb6deed2ec864cd3a1a0bc1f0e31f4c3af8212ea78308dbd7e82e0144"

  url "https://github.com/tvanreenen/key/releases/download/v0.2.0/Key-v0.2.0.zip"
  name "Key"
  desc "File-based secret manager with native authentication"
  homepage "https://github.com/tvanreenen/key"

  depends_on macos: :tahoe

  app "Key.app"
  binary "#{appdir}/Key.app/Contents/MacOS/key", target: "key"
  zsh_completion "completions/_key"

  caveats <<~EOS
    Open Key.app once after install so it can register Key Agent with macOS before you use the key CLI.
  EOS
end
