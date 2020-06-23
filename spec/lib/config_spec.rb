RSpec.describe JekyllMetrics::Config do
  subject(:config) { described_class.new(site) }
  let(:site) { OpenStruct.new(config: site_config, source: '/foo/boo/bar') }
  let(:site_config) { Jekyll::Configuration.from(jekyll_metrics: plugin_config) }
  let(:plugin_config) do
    {
      'template' => path,
      'yandex_metrica_id' => '22222222',
      'google_analytics_id' => '11-111111111-1'
    }
  end
  let(:path) { 'path/to/template.html' }
  let(:absolute_path) { '/path/to/template.html' }
  let(:default_path) do
    Pathname.new(__dir__).join('../..', JekyllMetrics::Config::DEFAULT_TEMPLATE_PATH)
  end

  describe '#plugin_vars' do
    specify { expect(config.plugin_vars).to include(plugin_config) }

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
end
