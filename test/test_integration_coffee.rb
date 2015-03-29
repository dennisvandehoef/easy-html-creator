include TestHelper

require 'generator/coffee_generator'

def reset_coffee
  File.delete("#{dev_root}/coffee/sub.coffee")
  FileUtils.copy("#{dev_root}/coffee/sub.org.coffee",
                 "#{dev_root}/coffee/sub.coffee")
end

describe Generator::CoffeeGenerator do
  before      { generate(generator) }
  after       { reset_coffee }

  let(:generator){ [Generator::StructureGenerator.new,
                    Generator::CoffeeGenerator.new
                    ] }

  let(:dev_root_coffee_file){ "#{dev_root}/coffee/main.coffee" }
  let(:dev_root_coffee_sub_file){ "#{dev_root}/coffee/sub.coffee" }
  let(:dev_root_coffee_sub_changed_file){ "#{dev_root}/coffee/sub.changed.coffee" }
  let(:web_root_coffee_file){ "#{web_root}/js/main.js" }
  let(:web_root_coffee_sub_file){ "#{web_root}/js/sub.js" }

  describe "#generate" do
    it "generates 'js/main.js' from 'coffee/main.coffee'" do
      file?(dev_root_coffee_file)
      file?(web_root_coffee_file)
    end

    it "'js/main.js' containes 'main.coffee' content" do
      file_containes?('main_coffee = true', web_root_coffee_file)
    end

    it "it regenerates 'coffee/sub.coffee' if changed" do
      file_containes?('sub_coffee = true', web_root_coffee_sub_file)

      File.delete(   dev_root_coffee_sub_file)
      FileUtils.copy(dev_root_coffee_sub_changed_file,
                     dev_root_coffee_sub_file)

      generate(generator)

      file_containes?('sub_coffee = false', web_root_coffee_sub_file)
    end
  end
end
