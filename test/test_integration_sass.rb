include TestHelper

def reset_sass
  File.delete("#{dev_root}/sass/_sub.sass")
  FileUtils.copy("#{dev_root}/sass/_sub.org.sass",
                 "#{dev_root}/sass/_sub.sass")
end

describe Generator::SassGenerator do
  Generator::SassGenerator::add_load_path('./test/fixtures/dev_root/shared/sass')

  before      { generate(generator) }
  after       { reset_sass }

  let(:generator){ [Generator::StructureGenerator.new,
                    Generator::SassGenerator.new
                    ] }

  let(:dev_root_sass_file){ "#{dev_root}/sass/main.sass" }
  let(:dev_root_sass_sub_file){ "#{dev_root}/sass/_sub.sass" }
  let(:dev_root_sass_sub_changed_file){ "#{dev_root}/sass/_sub.changed.sass" }
  let(:web_root_css_file){ "#{web_root}/css/main.css" }

  describe "#generate" do
    it "generates 'css/main.css' from 'sass/main.sass'" do
      file?(dev_root_sass_file)
      file?(web_root_css_file)
    end

    it "'css/main.css' containes 'main.sass' content" do
      file_containes?('background-color: green', web_root_css_file)
    end

    it "'css/main.css' containes '_sub.sass' content" do
      file_containes?('background-color: red', web_root_css_file)
    end

    it "'css/main.css' containes 'shared.sass' content" do
      file_containes?('background-color: blue', web_root_css_file)
    end

    it "it regenerates 'sass/main.sass' if 'sass/_sub.sass' changed" do

      File.delete(   dev_root_sass_sub_file)
      FileUtils.copy(dev_root_sass_sub_changed_file,
                     dev_root_sass_sub_file)

      generate(generator)

      file_containes?('background-color: orange', web_root_css_file)
    end
  end
end
