# frozen_string_literal: true

module JekyllMetrics
  # Compile metrics template and inject it into the page code
  class Hook
    attr_accessor :page

    def initialize(page)
      @page = page
      yield(@page, self) if block_given? && injectable?
    end

    def inject_scripts
      return unless injectable?

      document = Nokogiri::HTML(page.output)
      first_head_script = find_first_script(document)

      if first_head_script
        inject_after_first_script(first_head_script, document)
      else
        inject_before_closing_head(document)
      end

      page.output.replace(document.to_html)
    end

    private

    def injectable?
      production? && writable? && compiled_to_html_page? && can_be_modified?
    end

    def production?
      config.production?
    end

    def writable?
      [Jekyll::Document, Jekyll::Page].include?(page.class) || page.write?
    end

    def compiled_to_html_page?
      page.output_ext == '.html' || page.permalink&.end_with?('/')
    end

    def can_be_modified?
      page.output.match?('<html') && page.output.match('<\/head')
    end

    def inject_after_first_script(first_head_script, _document)
      first_head_script.add_previous_sibling(load_scripts)
    end

    def inject_before_closing_head(document)
      document&.xpath('//head')&.first&.add_child(load_scripts)
    end

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
