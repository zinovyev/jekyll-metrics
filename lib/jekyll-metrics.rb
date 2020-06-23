# frozen_string_literal: true

require 'jekyll'
require File.expand_path('jekyll-metrics/version', __dir__)
require File.expand_path('jekyll-metrics/config', __dir__)
require File.expand_path('jekyll-metrics/hook', __dir__)

module JekyllMetrics
  class ConfigurationError < StandardError; end
end

# Register the hook
Jekyll::Hooks.register [:documents, :pages], :post_render do |page|
  JekyllMetrics::Hook.new(page) { |_page, metrics| metrics.inject_scripts }
end
