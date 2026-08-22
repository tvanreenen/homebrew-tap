cask "frame" do
  version "3.1.2"
  sha256 "2fd23e81d1d3acd88b9d15183d8c7794380aef3c417f6d4de11c234b8d0b8916"

  url "https://github.com/tvanreenen/frame/releases/download/v#{version}/Frame-v#{version}.zip"
  name "Frame"
  desc "Keyboard-driven workspace and tiling window manager"
  homepage "https://github.com/tvanreenen/frame"

  livecheck do
    skip "Homebrew updates are published manually"
  end

  depends_on macos: :ventura # macOS 13+

  app "Frame-v#{version}/Frame.app"
  binary "Frame-v#{version}/bin/frame"

  postflight do
    system "/usr/bin/xattr", "-dr", "com.apple.quarantine", "#{staged_path}/Frame-v#{version}/bin/frame"
    system "/usr/bin/xattr", "-dr", "com.apple.quarantine", "#{appdir}/Frame.app"
  end
end
