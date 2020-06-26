# frozen_string_literal: true

RSpec.describe JekyllMetrics::Hook do
  subject(:hook) { described_class.new(page) }
  let(:page) { OpenStruct.new({ :site => nil }) }
  let(:config) do
    OpenStruct.new(
      :template_path => template_path,
      :plugin_vars   => {
        'template_path'       => template_path,
        'yandex_metrica_id'   => '22222222',
        'google_analytics_id' => '11-111111111-1',
      }
    )
  end
  let(:template_path) { File.expand_path('../../lib/jekyll-metrics/includes/metrics.html.liquid', __dir__) }

  describe '#load_scripts' do
    before do
      allow(hook).to receive(:config).and_return(config)
    end

    subject(:loaded_scripts) { hook.__send__(:load_scripts) }

    it { is_expected.to include('yandex.ru') }
    it { is_expected.to include('googletagmanager.com') }
    it { is_expected.to include('22222222') }
    it { is_expected.to include('11-111111111-1') }

    context 'when template_path is nil' do
      let(:template_path) {}
      specify do
        expect do
          hook.__send__(:load_scripts)
        end.to raise_error(JekyllMetrics::ConfigurationError, 'Template not found in path ""')
      end
    end
  end
end
