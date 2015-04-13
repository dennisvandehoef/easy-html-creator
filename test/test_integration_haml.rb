include TestHelper

describe Generator::HamlGenerator do
  before { cleanup
           generate(generator) }

  after { cleanup }

  let(:generator){ [Generator::StructureGenerator.new,
                    Generator::HamlGenerator.new
                    ] }

  let(:generated_file){ "#{web_root}/index.html" }

  describe "#generate" do
    it "creates the index.html" do
      file_containes?('index-haml', generated_file)
    end

    it "has content from layout.haml" do
      file_containes?('layout-haml', generated_file)
    end

    it "has content from header partial" do
      file_containes?('header-haml', generated_file)
    end

    it "has content from footer partial" do
      file_containes?('footer-haml', generated_file)
    end

    it "has content from nested partial" do
      file_containes?('nested-haml', generated_file)
    end

    it "has a css link" do
      file_containes?('.css', generated_file)
    end

    it "has a js link" do
      file_containes?('.js', generated_file)
    end

    it "has a image link" do
      file_containes?('.jpg', generated_file)
    end

    it "copies the 'dev_root/public/images' folder to 'web_root/images'" do
    end

    it "generates again on second run" do
      file?(generated_file)
      File.delete(generated_file)
      file?(generated_file, false)

      generate(generator)

      file?(generated_file)
    end
  end
end
