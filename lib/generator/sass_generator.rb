require 'sass'
require_relative 'base.rb'

#just require bootsrap and it will be in the sass path
require 'bootstrap-sass'

module Generator
  class SassGenerator < Generator::Base
    def self.add_load_path(path)
      ::Sass.load_paths << path unless ::Sass.load_paths.include?(path)
    end

    def generate(input_folder, output_folder)
      input_folder  = "#{input_folder}/sass"
      output_folder = "#{output_folder}/css"

      Dir.glob("#{input_folder}/*.sass").select do |input_file|
        file_name = input_file.split('/')[-1]
        next unless File.file? input_file and file_name[0] != '_'

        self.class.add_load_path input_folder

        output_file_name = file_name.gsub('.sass', '.css')
        output_file      = File.join(output_folder, output_file_name)

        compile_file(input_file, output_file)
      end
    end

    def compile(input, *args)
      engine = Sass::Engine.new(input)
      engine.render
    end

    def self.changed?(path)
      true #allways recompile sass because of imports
    end
  end
end
