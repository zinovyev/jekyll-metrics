module JekyllMetrics
  # Compile metrics template and inject it into the page code
  class Hook
    attr_accessor :page

    def initialize(page)
      @page = page
      yield(@page, self) if block_given? && injectable?
    end

    def injectable?
      ['Jekyll::Document', 'Jekyll::Page'].include?(page.class.name) || page.write? &&
        (page.output_ext == '.html' || page.permalink&.end_with?('/'))
    end

    def inject_scripts
      page.output.gsub!(%r{<\/head>}, load_scripts)
    end

    private

    def prepare_scripts_for(closing_tag)
      [load_scripts, "</#{closing_tag}>"].compact.join("\n")
    end

    def load_scripts
      verify_path!(config.template_path)

      render_template(File.read(config.template_path))
    end

    def verify_path!(path)
      return if path && File.exist?(path)

      raise ConfigurationError, "Template not found in path \"#{path}\""
    end

    def render_template(file)
      Liquid::Template.parse(file).render(config.plugin_vars)
    end

    def config
      @config ||= Config.instance(page.site)
    end
  end
end
