cask "key@alpha" do
  version "v0.2.0-alpha.7"
  sha256 "02d7c583d17148c09aa755b196c05d7e687a1e4467a0114614a330efcaa90bee"

  url "https://github.com/tvanreenen/key/releases/download/v0.2.0-alpha.7/Key-Preview-v0.2.0-alpha.7.zip"
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
