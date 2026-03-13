cask "key" do
  version "v0.1.0-alpha.2"
  sha256 "620d55e8ef9d20b3b36cb886afd2646278ee72d85fdb5fe36c3c98fec3555fd7"

  url "https://github.com/tvanreenen/key/releases/download/v0.1.0-alpha.2/Key-v0.1.0-alpha.2.zip"
  name "key"
  desc "macOS file-based secret manager with native auth"
  homepage "https://github.com/tvanreenen/key"

  app "Key.app"
  binary "#{appdir}/Key.app/Contents/MacOS/key", target: "key"
  zsh_completion "completions/_key"
end
