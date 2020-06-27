require 'spec_helper'

RSpec.describe JekyllMetrics do
  Jekyll.logger.log_level = :error

  let(:configs) do
    Jekyll.configuration(
      'full_rebuild' => true,
      'skip_config_files' => false,
      'collections' => { 'docs' => { 'output' => true }, 'secret' => {} },
      'source' => fixtures_dir,
      'destination' => dest_dir
    )
  end
  let(:site) { Jekyll::Site.new(configs) }
  let(:post_content) { read_file('jekyll/update/2020/06/24/welcome-to-jekyll.html') }
  let(:post_scripts) { grab_scripts(post_content) }
  let(:page_content) { read_file('about/index.html') }
  let(:page_scripts) { grab_scripts(page_content) }
  let(:empty_head_page_content) { read_file('without_scripts/index.html') }
  let(:empty_head_page_scripts) { grab_scripts(empty_head_page_content) }
  let(:empty_page_content) { read_file('index.html') }

  let(:expected_first_script) do
    <<~SCRIPT.tap { |s| strip_indents(s) }
      <script async src="https://www.googletagmanager.com/gtag/js?id=XX-XXXXXXXXX-X"></script>
    SCRIPT
  end

  let(:expected_second_script) do
    <<~SCRIPT.tap { |s| strip_indents(s) }
      <script>
        window.dataLayer = window.dataLayer || [];
        function gtag(){dataLayer.push(arguments);}
        gtag('js', new Date());

        gtag('config', 'XX-XXXXXXXXX-X');
      </script>
    SCRIPT
  end

  let(:expected_third_script) do
    <<~SCRIPT.tap { |s| strip_indents(s) }
      <script type="text/javascript">
         (function(m,e,t,r,i,k,a){m[i]=m[i]||function(){(m[i].a=m[i].a||[]).push(arguments)};
         m[i].l=1*new Date();k=e.createElement(t),a=e.getElementsByTagName(t)[0],k.async=1,k.src=r,a.parentNode.insertBefore(k,a)})
         (window, document, "script", "https://mc.yandex.ru/metrika/tag.js", "ym");

         ym(XXXXXXXX, "init", {
              clickmap:true,
              trackLinks:true,
              accurateTrackBounce:true
         });
      </script>
      <noscript><div><img src="https://mc.yandex.ru/watch/XXXXXXXX" style="position:absolute; left:-9999px;" alt=""></div></noscript>
      <!-- /Yandex.Metrika counter -->
    SCRIPT
  end

  let(:expected_fourth_script) do
    <<~SCRIPT.tap { |s| strip_indents(s) }
      <script>
        <!-- Comment -->
        alert('First alert!');
      </script>
    SCRIPT
  end

  let(:expected_fifth_script) do
    script = <<~SCRIPT
      <script>alert('Second alert!');</script>
    SCRIPT
    strip_indents(script)
  end

  before(:each) { site.process }

  RSpec.shared_examples 'scripts are rendered in a proper order' do |scripts_type|
    let(:scripts) { public_send(scripts_type) }

    it 'contains Google Analytics scripts' do
      expect(scripts[0]).to include(expected_first_script)
      expect(scripts[1]).to include(expected_second_script)
    end

    it 'contains Yandex Metrica scripts' do
      expect(scripts[2]).to include(expected_third_script)
    end

    if scripts_type == :empty_head_page_scripts
      it "doesn't render extra scripts" do
        expect(scripts[3]).to be_nil
        expect(scripts[4]).to be_nil
      end
    else
      it 'contains the first script content' do
        expect(scripts[3]).to include(expected_fourth_script)
      end

      it 'contains the second script body' do
        expect(scripts[4]).to include(expected_fifth_script)
      end
    end
  end

  specify 'empty page should remain empty' do
    expect(empty_page_content).to be_empty
  end

  context 'When post rendered' do
    it_behaves_like 'scripts are rendered in a proper order', :post_scripts
  end

  context 'When page rendered' do
    it_behaves_like 'scripts are rendered in a proper order', :page_scripts
  end

  context 'When page without layout scripts rendered' do
    it_behaves_like 'scripts are rendered in a proper order', :empty_head_page_scripts
  end
end
