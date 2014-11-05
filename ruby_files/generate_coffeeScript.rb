#!/usr/bin/env ruby

require "rubygems"
require "bundler/setup"

require 'fileutils'
require 'coffee-script'


class CoffeeGenerator
  def initialize
    @output_dir = "../web_root/"
  end

  def generate(folder, input_file)
    output = CoffeeScript.compile(File.read("../dev_root/#{folder}/coffee_files/#{input_file}"))


    file_name_a = input_file.split('.')
    file_name = file_name_a.take(file_name_a.size-1) * '.'

    output_path = File.join("#{@output_dir}#{folder}/js/", "#{file_name}.js")
    File.open(output_path, "w") do |f|
      f.write output
    end
  end
end

def generate_coffee_for(folder)
  g = CoffeeGenerator.new
  Dir.glob("../dev_root/#{folder}/coffee_files/*.coffee").select do |file|
    file_name = file.split('/')[-1]
    next unless File.file? file
    g.generate folder, file_name
  end

end
