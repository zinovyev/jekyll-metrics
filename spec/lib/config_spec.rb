# frozen_string_literal: true

RSpec.describe JekyllMetrics::Config do
  subject(:config) { described_class.new(site) }
  let(:site) { OpenStruct.new(:config => site_config, :source => '/foo/boo/bar') }
  let(:site_config) { Jekyll::Configuration.from(:jekyll_metrics => plugin_config) }
  let(:plugin_config) do
    {
      'template'            => path,
      'yandex_metrica_id'   => '22222222',
      'google_analytics_id' => '11-111111111-1',
      'environment'         => environment,
    }
  end
  let(:environment) {}
  let(:path) { 'path/to/template.html' }
  let(:absolute_path) { '/path/to/template.html' }
  let(:default_path) do
    Pathname.new(__dir__).join('../..', JekyllMetrics::Config::DEFAULT_TEMPLATE_PATH)
  end

  def reload_constant(constant, definition_path)
    paths = constant.split('::')
    constant_name = paths.pop
    parent_module = paths.empty? ? Object : Kernel.const_get(paths.join('::'))
    parent_module.send(:remove_const, constant_name)
    load root_path.join(definition_path)
  end

  describe '#plugin_vars' do
    let(:expected_plugin_config) do
      {
        'template'            => path,
        'yandex_metrica_id'   => '22222222',
        'google_analytics_id' => '11-111111111-1',
        'environment'         => 'production',
      }
    end

    specify { expect(config.plugin_vars).to include(expected_plugin_config) }

    context 'with default config' do
      let(:plugin_config) { OpenStruct.new({}) }

      specify do
        expect(config.plugin_vars).to include(JekyllMetrics::Config::DEFAULT_CONFIG)
      end
    end
  end

  describe '#template_path' do
    specify { expect(config.template_path).to eq(Pathname.new('/foo/boo/bar/path/to/template.html')) }

    context 'with absolute path' do
      let(:path) { absolute_path }

      specify { expect(config.template_path).to eq(Pathname.new(absolute_path)) }
    end

    context 'with default config' do
      let(:plugin_config) { OpenStruct.new({}) }

      specify do
        expect(config.template_path).to eq(default_path)
      end
    end
  end

  describe '#production?' do
    specify { expect(config.production?).to eq(true) }

    context 'when given directly' do
      let(:environment) { 'development' }

      specify { expect(config.production?).to eq(false) }
    end

    context 'when defined with ENV variable' do
      before do
        ENV['JEKYLL_ENV'] = 'development'
        reload_constant('JekyllMetrics::Config::DEFAULT_CONFIG', 'lib/jekyll-metrics/config.rb')
      end

      after(:all) do
        ENV.delete('JEKYLL_ENV')
        reload_constant('JekyllMetrics::Config::DEFAULT_CONFIG', 'lib/jekyll-metrics/config.rb')
      end

      specify { expect(config.production?).to eq(false) }
    end
  end
end
