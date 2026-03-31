cask "key" do
  version "v0.1.0"
  sha256 "8cd87cae22f22ddbdb44a01f194d93a0d7caa0493ca9f6baffb36d5a882b85f1"

  url "https://github.com/tvanreenen/key/releases/download/v0.1.0/Key-v0.1.0.zip"
  name "key"
  desc "macOS file-based secret manager with native auth"
  homepage "https://github.com/tvanreenen/key"

  app "Key.app"
  binary "#{appdir}/Key.app/Contents/MacOS/key", target: "key"
  zsh_completion "completions/_key"

  caveats <<~EOS
    Open Key.app once after install so it can register Key Agent with macOS before you use the key CLI.
  EOS
end
