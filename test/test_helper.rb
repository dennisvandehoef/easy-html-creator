require "minitest/reporters"
require 'fileutils'

module TestHelper
  Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

  def self.require_lib(relative_path)
    require_relative "./../lib/#{relative_path}"
  end

  def self.dev_root_path
    "test/fixtures/dev_root"
  end

  def self.web_root_path
    "test/fixtures/web_root"
  end

  def self.generate(generators)
    self.cleanup

    generators = [generators] unless generators.kind_of?(Array)

    generators.each do |generator|
      generator.generate("#{TestHelper::dev_root_path}/test",
                         "#{TestHelper::web_root_path}/test")
    end
  end

  def self.cleanup
    FileUtils.rm_rf(TestHelper::web_root_path)
  end

  def self.reset_bower
    File.delete("#{TestHelper::dev_root_path}/test/public/bower.json")
    FileUtils.copy("#{TestHelper::dev_root_path}/test/public/bower.org.json",
                   "#{TestHelper::dev_root_path}/test/public/bower.json")
  end
end
