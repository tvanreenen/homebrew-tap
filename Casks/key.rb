cask "key" do
  version "v0.1.0-alpha.1"
  sha256 "e37c4aaec9d5f30be49bbca56a7bbf5cc8a1ce62a1adc6e3422e027b73b1555e"

  url "https://github.com/tvanreenen/key/releases/download/v0.1.0-alpha.1/Key-v0.1.0-alpha.1.zip"
  name "key"
  desc "macOS file-based secret manager with native auth"
  homepage "https://github.com/tvanreenen/key"

  app "Key.app"
  binary "\#{appdir}/Key.app/Contents/MacOS/key", target: "key"
end
