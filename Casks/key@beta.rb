cask "key@beta" do
  version "v0.2.0-beta.1"
  sha256 "8216afea14a4de764b0b844f2c6ff30c035b0ce7eb510bece7f02aa8e81b5b64"

  url "https://github.com/tvanreenen/key/releases/download/v0.2.0-beta.1/Key-Preview-v0.2.0-beta.1.zip"
  name "Key Preview"
  desc "File-based secret manager with native authentication"
  homepage "https://github.com/tvanreenen/key"

  conflicts_with cask: ["key@alpha", "key@rc"]
  depends_on macos: :tahoe

  app "Key Preview.app"
  binary "#{appdir}/Key Preview.app/Contents/MacOS/key-preview", target: "key-preview"

  caveats <<~EOS
    Open Key Preview.app once after install so it can register Key Preview Agent with macOS before you use the key-preview CLI.
  EOS
end
