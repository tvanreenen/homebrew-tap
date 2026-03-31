cask "key" do
  version "v0.1.1"
  sha256 "6d12236ea21e3a3933d5f75f3d8a57040868bc969a3ff8caba5f27f22367f898"

  url "https://github.com/tvanreenen/key/releases/download/v0.1.1/Key-v0.1.1.zip"
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
