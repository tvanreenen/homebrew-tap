cask "key@alpha" do
  version "v0.2.0-alpha.11"
  sha256 "8ff1bab3824ccc98988aaa7f05219d36073b2f629e377fb24d7e2a8250d9ef6c"

  url "https://github.com/tvanreenen/key/releases/download/v0.2.0-alpha.11/Key-Preview-v0.2.0-alpha.11.zip"
  name "Key Preview"
  desc "File-based secret manager with native authentication"
  homepage "https://github.com/tvanreenen/key"

  conflicts_with cask: ["key@beta", "key@rc"]
  depends_on macos: :tahoe

  app "Key Preview.app"
  binary "#{appdir}/Key Preview.app/Contents/MacOS/key-preview", target: "key-preview"

  caveats <<~EOS
    Open Key Preview.app once after install so it can register Key Preview Agent with macOS before you use the key-preview CLI.
  EOS
end
