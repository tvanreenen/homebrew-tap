class Xkcdpass < Formula
  desc "High-entropy password generator inspired by xkcd #936"
  homepage "https://github.com/tvanreenen/xkcdpass"
  url "https://github.com/tvanreenen/xkcdpass/releases/download/v0.2.0/xkcdpass_v0.2.0_darwin_arm64.tar.gz"
  sha256 "7a74a0d2264c63476e2524851c9bb5cb0c3691166f8ec88ecc5710036878c289"
  license "MIT"

  def install
    bin.install "xkcdpass"
  end

  test do
    output = shell_output(bin/"xkcdpass")
    assert_match(/\A[a-z]+\n\z/, output)
  end
end
