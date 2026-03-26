cask "key" do
  version "v0.1.0-alpha.3"
  sha256 "9acd4522f8678b95fdf3f0486df2f17b6f2e10f0ddd965025a773ff3f04e2311"

  url "https://github.com/tvanreenen/key/releases/download/v0.1.0-alpha.3/Key-v0.1.0-alpha.3.zip"
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
