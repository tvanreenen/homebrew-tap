cask "key@alpha" do
  version "v0.2.0-alpha.8"
  sha256 "c3a8c2b33e2ef95297f64bc667473244a7f68de25d8e22daf959b14713714e16"

  url "https://github.com/tvanreenen/key/releases/download/v0.2.0-alpha.8/Key-Preview-v0.2.0-alpha.8.zip"
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
