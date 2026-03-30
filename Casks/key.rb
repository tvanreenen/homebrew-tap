cask "key" do
  version "v0.1.0-beta.3"
  sha256 "a264392fffc1ef6c4ca99aef18ba82eeaef2e6d27f2da7d6cf2ee231333c88c9"

  url "https://github.com/tvanreenen/key/releases/download/v0.1.0-beta.3/Key-v0.1.0-beta.3.zip"
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
