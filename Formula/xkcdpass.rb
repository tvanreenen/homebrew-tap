class Xkcdpass < Formula
  desc "High-entropy password generator inspired by xkcd #936"
  homepage "https://github.com/tvanreenen/xkcdpass"
  url "https://github.com/tvanreenen/xkcdpass/releases/download/v0.2.1/xkcdpass_v0.2.1_darwin_arm64.tar.gz"
  sha256 "b7b9a99f09df88eab8a1cb77ea09f0b41e8a2424e6a2b41f8d52104e7cac5342"
  license "MIT"

  def install
    bin.install "xkcdpass"
  end

  test do
    output = shell_output(bin/"xkcdpass")
    assert_match(/\A[a-z]+\n\z/, output)
  end
end
