require_relative 'sass.rb'
require_relative 'coffee.rb'
require_relative 'haml.rb'
require_relative 'structure.rb'

module Generator
  class Generator
    def initialize
      @haml      = Haml.new
      @sass      = Sass.new
      @coffee    = Coffee.new
      @structure = Structure.new
    end

    def generate
      FileUtils.rm_rf(Dir.glob("web_root/*"))

      Dir.glob('dev_root/*').select do |folder|
        next unless File.directory? folder
        next if folder.include? 'shared'
        folder = folder.split('/')[-1]

        @structure.generate folder
        @sass.generate folder
        @coffee.generate folder
        @haml.generate folder
      end
    end
  end
end
