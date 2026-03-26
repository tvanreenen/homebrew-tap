cask "key" do
  version "v0.1.0-beta.2"
  sha256 "9135629e707a1dc29338d6fc00258090b167d1bf4aabe20aa6b04ce3f9a1e008"

  url "https://github.com/tvanreenen/key/releases/download/v0.1.0-beta.2/Key-v0.1.0-beta.2.zip"
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
