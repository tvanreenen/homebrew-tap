cask "key" do
  version "v0.2.0-alpha.1"
  sha256 "9f338b6db1fe43e3dba04f9b6c33defe548df960ffa55059962abdcfe0dd43c2"

  url "https://github.com/tvanreenen/key/releases/download/v0.2.0-alpha.1/Key-v0.2.0-alpha.1.zip"
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
