require 'fileutils'
require 'coffee-script'

module Generator
  class Coffee
    def generate
      g = CoffeeGenerator.new
      Dir.glob("dev_root/#{folder}/coffee/*.coffee").select do |file|
        file_name = file.split('/')[-1]
        next unless File.file? file
        g.generate folder, file_name
      end
    end

    def _generate(folder, input_file)
      output = CoffeeScript.compile(File.read("dev_root/#{folder}/coffee/#{input_file}"))

      file_name_a = input_file.split('.')
      file_name = file_name_a.take(file_name_a.size-1) * '.'

      output_path = File.join("web_root/#{folder}/js/", "#{file_name}.js")
      File.open(output_path, "w") do |f|
        f.write output
      end
    end
  end
end
