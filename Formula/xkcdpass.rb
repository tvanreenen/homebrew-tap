class Xkcdpass < Formula
  desc "Generate xkcd-style passphrases from the EFF large wordlist"
  homepage "https://github.com/tvanreenen/xkcdpass"
  url "https://github.com/tvanreenen/xkcdpass/releases/download/v0.1.0/xkcdpass_v0.1.0_darwin_arm64.tar.gz"
  sha256 "b7abbb25be4beeb93107d201014b9d72e58ead2c18c085018438aa019d0e7c76"
  license "MIT"

  def install
    bin.install "xkcdpass"
  end

  test do
    output = shell_output("#{bin}/xkcdpass")
    assert_match(/\A[a-z]+\n\z/, output)
  end
end

