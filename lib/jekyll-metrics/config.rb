module JekyllMetrics
  # Hold the configuration needed for {JekyllMetrics::Hook} to work
  class Config
    CONFIG_NAME = 'jekyll_metrics'.freeze
    DEFAULT_TEMPLATE_PATH = 'lib/jekyll-metrics/includes/metrics.html.liquid'.freeze
    DEFAULT_CONFIG = {
      'template' => DEFAULT_TEMPLATE_PATH,
      'yandex_metrica_id' => 'XXXXXXXX',
      'google_analytics_id' => 'XX-XXXXXXXXX-X'
    }.freeze

    class << self
      def instance(site)
        @instance ||= Config.new(site)
      end
    end

    attr_accessor :site

    def initialize(site)
      @site = site
    end

    def template_path
      @template_path ||= build_template_path
    end

    def plugin_vars
      @plugin_vars ||= DEFAULT_CONFIG.merge(plugin_config)
    end

    private

    def build_template_path
      custom_path = plugin_config['template']

      return default_template_path if custom_path.nil?

      if custom_path.match?(%r{^\/})
        Pathname.new(custom_path)
      else
        site_root_path.join(custom_path)
      end
    end

    def default_template_path
      plugin_root_path.join(DEFAULT_TEMPLATE_PATH)
    end

    def plugin_root_path
      Pathname.new(File.expand_path('../..', __dir__))
    end

    def site_root_path
      raise ConfigurationError, 'Couldn\'t access site.source' unless site.source

      Pathname.new(site.source)
    end

    def plugin_config
      @plugin_config ||= site_config[CONFIG_NAME].to_h.transform_keys(&:to_s)
    end

    def site_config
      site.config
    end
  end
end
