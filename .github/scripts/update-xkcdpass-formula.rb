#!/usr/bin/env ruby
# frozen_string_literal: true

abort "usage: #{$PROGRAM_NAME} <input> <output> <version> <darwin-sha256> <linux-sha256>" if ARGV.length != 5

input_path, output_path, version, darwin_sha256, linux_sha256 = ARGV
abort "invalid version" unless version.match?(/\A\d+\.\d+\.\d+(?:-[0-9A-Za-z.-]+)?(?:\+[0-9A-Za-z.-]+)?\z/)
abort "invalid Darwin SHA-256" unless darwin_sha256.match?(/\A[0-9a-f]{64}\z/)
abort "invalid Linux SHA-256" unless linux_sha256.match?(/\A[0-9a-f]{64}\z/)
abort "output already exists" if File.exist?(output_path)

contents = File.read(input_path)
platforms = {
  "darwin_arm64" => darwin_sha256,
  "linux_amd64"  => linux_sha256,
}

platforms.each do |platform, sha256|
  pattern = %r{^(\s*)url "https://github\.com/tvanreenen/xkcdpass/releases/download/v[^/"]+/xkcdpass_v[^/"]+_#{platform}\.tar\.gz"\n\1sha256 "[0-9a-f]{64}"}
  abort "formula must contain exactly one #{platform} release block" if contents.scan(pattern).length != 1

  contents = contents.sub(pattern) do
    indentation = ::Regexp.last_match(1)
    url = "https://github.com/tvanreenen/xkcdpass/releases/download/v#{version}/xkcdpass_v#{version}_#{platform}.tar.gz"
    %Q(#{indentation}url "#{url}"\n#{indentation}sha256 "#{sha256}")
  end
end

File.write(output_path, contents)
