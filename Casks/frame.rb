cask "frame" do
  version "3.1.3"
  sha256 "3f447e3331f85fc42e831cdc60334b8db5d1ad5a5fcb9cfeb77fd0619d2185ea"

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

  postflight_steps do
    run "/usr/bin/xattr",
        args:         ["-dr", "com.apple.quarantine", "{{staged_path}}/Frame-v{{version}}/bin/frame"],
        must_succeed: false
    run "/usr/bin/xattr",
        args:         ["-dr", "com.apple.quarantine", "{{appdir}}/Frame.app"],
        must_succeed: false
  end
end
