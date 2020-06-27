require_relative 'lib/jekyll-metrics/version'

Gem::Specification.new do |spec|
  spec.name          = 'jekyll-metrics'
  spec.version       = JekyllMetrics::VERSION
  spec.authors       = ['Ivan Zinovyev']
  spec.email         = ['ivan@zinovyev.net']

  spec.summary       = 'Metrics plugin for Jekyll'
  spec.description   = 'Metrics plugin for Jekyll. Supports Yandex Metrics and Google Analytics out of the box.'
  spec.homepage      = 'https://github.com/zinovyev/jekyll-metrics'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage

  spec.files            = Dir['lib/**/*']
  spec.extra_rdoc_files = Dir['README.md', 'LICENSE.txt']
  spec.require_paths    = ['lib']

  spec.add_dependency 'jekyll', '>= 3.7', '< 5.0'
  spec.add_dependency 'nokogiri'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'pry'
end
