require 'fileutils'
require 'coffee-script'

module Generator
  class CoffeeGenerator
    def generate input_folder, output_folder
      Dir.glob("#{input_folder}/*.coffee").select do |file|
        next unless File.file? file

        result = compile(file)
        file_name = file.split('/')[-1].gsub('.coffee', '.js')
        write File.join(output_folder, file_name), result
      end
    end

    def compile file
      CoffeeScript.compile(File.read(file))
    end

    def write file, content
      File.open(file, "w") do |f|
        f.write content
      end
    end
  end
end
