require 'minitest/autorun'
require 'fileutils'
require './test/test_helper'

TestHelper::require_lib 'generator/structure_generator'

describe Generator::StructureGenerator do
  before { TestHelper::generate generator }
  after  { TestHelper::cleanup }

  let(:generator){ Generator::StructureGenerator.new }

  let(:dev_root){ "#{TestHelper::dev_root_path}/test" }
  let(:web_root){ "#{TestHelper::web_root_path}/test" }
  let(:dev_root_image){ "#{dev_root}/public/images/easy-way.jpg" }
  let(:web_root_image){ "#{web_root}/images/easy-way.jpg" }

  describe "#generate" do
    it "creates the output folder " do
      File.directory?(web_root).must_equal true
    end

    it "creates the css output folder " do
      File.directory?("#{web_root}/css").must_equal true
    end

    it "creates the js output folder " do
      File.directory?("#{web_root}/js").must_equal true
    end

    it "copies the 'dev_root/public/robots.txt' to 'web_root/robots.txt'" do
      File.file?("#{dev_root}/public/robots.txt").must_equal true
      File.file?("#{web_root}/robots.txt").must_equal true
    end

    it "copies the 'dev_root/public/images' folder to 'web_root/images'" do
      File.directory?("#{dev_root}/public/images").must_equal true
      File.directory?("#{web_root}/images").must_equal true
      File.file?(web_root_image).must_equal true
    end

    it "copies again on second run" do
      File.file?(web_root_image).must_equal true
      File.delete(web_root_image)
      File.file?(web_root_image).must_equal false

      TestHelper::generate generator

      File.file?(web_root_image).must_equal true
    end
  end
end
