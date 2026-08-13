cask "key@alpha" do
  version "v0.2.0-alpha.9"
  sha256 "e101ce9819000af8cd84e5becb734b9bb4efba058326fd9be511ea497d4f1451"

  url "https://github.com/tvanreenen/key/releases/download/v0.2.0-alpha.9/Key-Preview-v0.2.0-alpha.9.zip"
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
