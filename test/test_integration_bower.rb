require 'minitest/autorun'
require 'fileutils'
require './test/test_helper'

TestHelper::require_lib 'generator/bower_generator'

describe Generator::BowerGenerator do
  # cleanup all resolved bower_components
  #FileUtils.rm_rf("#{TestHelper::dev_root_path}/test/public/bower_components")

  before { TestHelper::generate generator }
  after  { TestHelper::cleanup
           TestHelper::reset_bower}

  let(:generator){ [Generator::BowerGenerator.new,
                    Generator::StructureGenerator.new
                    ] }

  let(:dev_root){ "#{TestHelper::dev_root_path}/test" }
  let(:web_root){ "#{TestHelper::web_root_path}/test" }
  let(:dev_root_bower_file){ "#{dev_root}/public/bower.json" }
  let(:web_root_bower_file){ "#{web_root}/bower.json" }

  describe "#generate" do
    it "a bower.json file exists" do
      File.file?(dev_root_bower_file).must_equal true
      File.file?(web_root_bower_file).must_equal true
    end

    it "resolves the bower file " do
      File.directory?("#{dev_root}/public/bower_components").must_equal true
      File.directory?("#{web_root}/bower_components").must_equal true
    end

    it "it regenerates if bower.json changed" do
      File.directory?("#{web_root}/bower_components/jquery").must_equal true
      FileUtils.rm_rf("#{web_root}/bower_components")

      File.delete(   "#{TestHelper::dev_root_path}/test/public/bower.json")
      FileUtils.copy("#{TestHelper::dev_root_path}/test/public/bower.changed.json",
                     "#{TestHelper::dev_root_path}/test/public/bower.json")

      TestHelper::generate generator

      File.directory?("#{web_root}/bower_components/jquery").must_equal true
      File.directory?("#{web_root}/bower_components/bootstrap").must_equal true
    end
  end
end
