class Xkcdpass < Formula
  desc "High-entropy password generator inspired by xkcd #936"
  homepage "https://github.com/tvanreenen/xkcdpass"
  url "https://github.com/tvanreenen/xkcdpass/releases/download/v0.1.1/xkcdpass_v0.1.1_darwin_arm64.tar.gz"
  sha256 "b634bd67d8be2ef6d7b96165488bcfda6cf0052bb627b589da85d59e33f70978"
  license "MIT"

  def install
    bin.install "xkcdpass"
  end

  test do
    output = shell_output(bin/"xkcdpass")
    assert_match(/\A[a-z]+\n\z/, output)
  end
end
