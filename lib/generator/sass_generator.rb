require 'fileutils'
require 'sass'

#just require bootsrap and it will be in the sass path
require 'bootstrap-sass'

module Generator
  class SassGenerator
    def generate input_folder, output_folder
      Dir.glob("#{input_folder}/*.sass").select do |file|
        file_name = file.split('/')[-1]
        next unless File.file? file and file_name[0] != '_'

        result = compile(file)
        file_name = file.split('/')[-1].gsub('.sass', '.css')
        write File.join(output_folder, file_name), result
      end
    end

    def compile file
      engine = Sass::Engine.new(File.read(file))
      engine.render
    end

    def write file, content
      File.open(file, "w") do |f|
        f.write content
      end
    end
  end
end
