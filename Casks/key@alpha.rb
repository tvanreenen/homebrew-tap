cask "key@alpha" do
  version "v0.2.0-alpha.10"
  sha256 "85e92976b8d45e4da6ef2d736412d347cd554249873fa59043533c5452f96ce4"

  url "https://github.com/tvanreenen/key/releases/download/v0.2.0-alpha.10/Key-Preview-v0.2.0-alpha.10.zip"
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
