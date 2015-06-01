require 'coffee_script'
require 'uglifier'

require_relative 'base.rb'

module Generator
  class CoffeeGenerator < Generator::Base
    def generate(input_folder, output_folder)
      input_folder  = "#{input_folder}/coffee"
      output_folder = "#{output_folder}/js"

      Dir.glob("#{input_folder}/*.coffee").select do |input_file|
        next unless File.file? input_file

        output_file_name = input_file.split('/')[-1].gsub('.coffee', '.js')
        outpu_file       = File.join(output_folder, output_file_name)

        compile_file(input_file, outpu_file)

        min_file_name = outpu_file.sub '.js', '.min.js'
        File.write(min_file_name,
                   Uglifier.compile(
                      File.read(outpu_file)))
      end
    end

    def compile(input, *args)
      CoffeeScript.compile(input)
    rescue Exception => e
      raise $!, "#{$!} TEMPLATE::#{args.to_s} ", $!.backtrace
    end
  end
end
