cask "key" do
  version "v0.1.2"
  sha256 "48532e729c3655e91bbfbe644542cdc445b3b9627de2430cc712502957e65595"

  url "https://github.com/tvanreenen/key/releases/download/v0.1.2/Key-v0.1.2.zip"
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
