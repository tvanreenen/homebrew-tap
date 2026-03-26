cask "key" do
  version "v0.1.0-beta.1"
  sha256 "f71b212037c4451210045a388605efec6e60613ebcbe755b7bdcdee3d5f733b8"

  url "https://github.com/tvanreenen/key/releases/download/v0.1.0-beta.1/Key-v0.1.0-beta.1.zip"
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
