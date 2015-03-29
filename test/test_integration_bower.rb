include TestHelper

require 'generator/bower_generator'

def reset_bower
  File.delete("#{dev_root_path}/test/public/bower.json")
  FileUtils.copy("#{dev_root_path}/test/public/bower.org.json",
                 "#{dev_root_path}/test/public/bower.json")
end

describe Generator::BowerGenerator do
  # cleanup all resolved bower_components
  FileUtils.rm_rf("#{dev_root_path}/test/public/bower_components")

  before { cleanup
           generate(generator) }

  after  { cleanup
           reset_bower}

  let(:generator){ [Generator::BowerGenerator.new,
                    Generator::StructureGenerator.new
                    ] }

  let(:dev_root_bower_file){ "#{dev_root}/public/bower.json" }
  let(:web_root_bower_file){ "#{web_root}/bower.json" }

  describe "#generate" do
    it "a bower.json file exists" do
      file?(dev_root_bower_file)
      file?(web_root_bower_file)
    end

    it "resolves the bower file " do
      directory?("#{dev_root}/public/bower_components")
      directory?("#{web_root}/bower_components")
    end

    it "it regenerates if bower.json changed" do
      directory?("#{web_root}/bower_components/jquery")
      FileUtils.rm_rf("#{web_root}/bower_components")

      File.delete(   "#{dev_root_path}/test/public/bower.json")
      FileUtils.copy("#{dev_root_path}/test/public/bower.changed.json",
                     "#{dev_root_path}/test/public/bower.json")

      generate(generator)

      directory?("#{web_root}/bower_components/jquery")
      directory?("#{web_root}/bower_components/bootstrap")
    end
  end
end
