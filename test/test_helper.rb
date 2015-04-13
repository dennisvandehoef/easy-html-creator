require 'minitest/reporters'
require 'minitest/autorun'
require 'fileutils'

require 'generator/structure_generator'
require 'generator/sass_generator'
require 'generator/bower_generator'
require 'generator/coffee_generator'
require 'generator/haml_generator'

module TestHelper
  Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

  MiniTest::after_run { cleanup }

  def dev_root_path
    "test/fixtures/dev_root"
  end

  def web_root_path
    "test/fixtures/web_root"
  end

  def dev_root
    "#{dev_root_path}/test"
  end

  def web_root
    "#{web_root_path}/test"
  end

  def file_containes?(sub_string, file)
    content = File.open(file, "rb") { |io| io.read }

    content.must_include(sub_string)
  end

  def generate(generators)
    generators = [generators] unless generators.kind_of?(Array)

    generators.each do |generator|
      generator.generate("#{dev_root_path}/test",
                         "#{web_root_path}/test")
    end
  end

  def cleanup
    FileUtils.rm_rf(web_root_path)
  end

  def directory?(path, equals=true)
    File.directory?(path).must_equal equals
  end

  def file?(path, equals=true)
    File.file?(path).must_equal equals
  end
end
