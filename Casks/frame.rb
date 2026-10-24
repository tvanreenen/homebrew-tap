cask "frame" do
  version "3.2.0"
  sha256 "840da5ded27fc57505b1c92d23e2826fb42103c3a7661699fb74e09bb718978d"

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
