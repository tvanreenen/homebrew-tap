#!/usr/bin/env ruby
# frozen_string_literal: true

abort "usage: #{$PROGRAM_NAME} <template> <output> <token> <version> <sha256>" if ARGV.length != 5

template_path, output_path, token, version, sha256 = ARGV
abort "invalid token" unless token.match?(/\Akey@(alpha|beta|rc)\z/)
abort "invalid version" unless version.match?(/\Av\d+\.\d+\.\d+-(alpha|beta|rc)\.\d+\z/)
version_channel = version.split("-", 2).last.split(".", 2).first
abort "token and version channels differ" if token.delete_prefix("key@") != version_channel
abort "invalid SHA-256" unless sha256.match?(/\A[0-9a-f]{64}\z/)
abort "output already exists" if File.exist?(output_path)

channels = %w[alpha beta rc]
conflicts = channels.reject { |channel| token.end_with?(channel) }
replacements = {
  "@TOKEN@"     => token,
  "@VERSION@"   => version,
  "@SHA256@"    => sha256,
  "@CONFLICTS@" => conflicts.map { |channel| "\"key@#{channel}\"" }.join(", "),
}

contents = File.read(template_path)
replacements.each do |placeholder, replacement|
  abort "template must contain #{placeholder} exactly once" if contents.scan(placeholder).length != 1
  contents = contents.sub(placeholder, replacement)
end
abort "unexpanded template placeholder" if contents.match?(/@[A-Z]+@/)

File.write(output_path, contents)
