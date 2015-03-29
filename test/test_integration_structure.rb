include TestHelper

require 'generator/structure_generator'

describe Generator::StructureGenerator do
  before { cleanup
           generate(generator) }

  after { cleanup }

  let(:generator){ Generator::StructureGenerator.new }

  let(:dev_root_image){ "#{dev_root}/public/images/easy-way.jpg" }
  let(:web_root_image){ "#{web_root}/images/easy-way.jpg" }

  describe "#generate" do
    it "creates the output folder" do
      directory?(web_root)
    end

    it "creates the css output folder" do
      directory?("#{web_root}/css")
    end

    it "copies the 'public/css' folder to output folder" do
      file?("#{web_root}/css/public.css")
    end

    it "copies the 'public/js' folder to output folder" do
      file?("#{web_root}/js/public.js")
    end

    it "copies the 'dev_root/public/robots.txt' to 'web_root/robots.txt'" do
      file?("#{dev_root}/public/robots.txt")
      file?("#{web_root}/robots.txt")
    end

    it "copies the 'dev_root/public/images' folder to 'web_root/images'" do
      directory?("#{dev_root}/public/images")
      directory?("#{web_root}/images")
      file?(web_root_image)
    end

    it "copies again on second run" do
      file?(web_root_image)
      File.delete(web_root_image)
      file?(web_root_image, false)

      generate(generator)

      file?(web_root_image)
    end
  end
end
