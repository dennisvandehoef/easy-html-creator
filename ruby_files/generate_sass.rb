#!/usr/bin/env ruby

require "rubygems"
require "bundler/setup"

require 'fileutils'
require "sass"


class SassGenerator
  def initialize
    @output_dir = "../web_root/"
  end

  def generate(folder, input_file)
    engine = Sass::Engine.new(File.read("../dev_root/#{folder}/sass_files/#{input_file}"))

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
  Dir.glob("../dev_root/#{folder}/sass_files/*.sass").select do |file|
    file_name = file.split('/')[-1]
    next unless File.file? file
    g.generate folder, file_name
  end

end
