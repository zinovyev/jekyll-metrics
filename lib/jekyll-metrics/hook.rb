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
      return unless page.output.match?('html')

      document = Nokogiri::HTML(page.output)
      first_head_script = find_first_script(document)

      return unless first_head_script

      first_head_script.add_previous_sibling(load_scripts)
      page.output.replace(document.to_html)
    end

    private

    def find_first_script(document)
      document&.xpath('//head')&.xpath('script')&.first
    end

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
