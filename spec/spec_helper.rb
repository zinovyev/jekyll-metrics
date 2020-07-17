require 'pry'
require 'bundler/setup'
require 'jekyll-metrics'
require File.expand_path('../lib/jekyll-metrics', __dir__)

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  # config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  SOURCE_DIR = File.expand_path('fixtures', __dir__)
  DEST_DIR   = File.expand_path('dest',     __dir__)

  def fixtures_dir(*files)
    File.join(SOURCE_DIR, *files)
  end

  def dest_dir(*files)
    File.join(DEST_DIR, *files)
  end

  def read_file(path_to)
    File.read(dest_path.join(path_to)).strip
  end

  def root_path
    @root_path ||= Pathname.new(File.expand_path('..', __dir__))
  end

  def dest_path
    @dest_path ||= Pathname.new(File.expand_path('dest', __dir__))
  end

  def grab_scripts(content)
    return if content.nil?

    splitted_content = content.split('</head>').first&.split(%r!(?=\<script)!)&.map { |l| strip_indents(l) } || []
    splitted_content.shift # Remove the <!DOCTYPE html>... part
    splitted_content
  end

  def strip_indents(script)
    return unless script

    script.replace(strip_indents_in_lines(script))
  end

  def strip_indents_in_lines(script)
    script.split(%r!(?<=\\n$)!).map { |line| line.gsub(%r!^\s+!, '')&.strip }.join("\n").strip
  end
end
