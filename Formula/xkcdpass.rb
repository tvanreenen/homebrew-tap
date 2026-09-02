class Xkcdpass < Formula
  desc "High-entropy password generator inspired by xkcd #936"
  homepage "https://github.com/tvanreenen/xkcdpass"
  license "MIT"

  stable do
    version "0.2.1"

    on_macos do
      url "https://github.com/tvanreenen/xkcdpass/releases/download/v0.2.1/xkcdpass_v0.2.1_darwin_arm64.tar.gz"
      sha256 "b7b9a99f09df88eab8a1cb77ea09f0b41e8a2424e6a2b41f8d52104e7cac5342"
    end

    on_linux do
      url "https://github.com/tvanreenen/xkcdpass/releases/download/v0.2.1/xkcdpass_v0.2.1_linux_amd64.tar.gz"
      sha256 "1b218e5d85ba06a38a9b18ec087519bba86817c58e7e966147083bc33f72c266"
    end
  end

  head do
    url "https://github.com/tvanreenen/xkcdpass.git", branch: "main"

    depends_on "go" => :build
  end

  on_macos do
    depends_on arch: :arm64
    depends_on macos: :ventura
  end

  on_linux do
    depends_on arch: :x86_64
  end

  def install
    if build.head?
      ldflags = "-s -w -X main.version=#{version}"
      system "go", "build", *std_go_args(ldflags:), "./cmd/xkcdpass"
    else
      bin.install "xkcdpass"
    end
  end

  test do
    expected_version = build.head? ? version.to_s : "v#{version}"
    assert_equal expected_version, shell_output("#{bin}/xkcdpass --version").chomp

    output = shell_output(bin/"xkcdpass")
    assert_match(/\A[a-z]+\n\z/, output)
  end
end
