#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'

require 'fileutils'
require 'sass'

#just require bootsrap and it will be in the sass path
require 'bootstrap-sass'

class SassGenerator
  def initialize
    @output_dir = "web_root/"
  end

  def generate(folder, input_file)
    engine = Sass::Engine.new(File.read("dev_root/#{folder}/sass/#{input_file}"))

    file_name_a = input_file.split('.')
    file_name = file_name_a.take(file_name_a.size-1) * '.'

    output_path = File.join("#{@output_dir}#{folder}/css/", "#{file_name}.css")
    File.open(output_path, "w") do |f|
      f.write engine.render
    end
  end
end

def generate_sass_for(folder)
  g = SassGenerator.new

  Dir.glob("dev_root/#{folder}/sass/*.sass").select do |file|
    file_name = file.split('/')[-1]
    next unless File.file? file and file_name[0] != '_'
    g.generate folder, file_name
  end

end
