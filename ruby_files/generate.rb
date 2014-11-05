#!/usr/bin/env ruby

require "rubygems"
require "bundler/setup"

require 'fileutils'

require './generate_haml.rb'
require './generate_sass.rb'

def generate_files
  FileUtils.rm_rf(Dir.glob("../web_root/*"))

  Dir.glob('../dev_root/*').select do |folder|
    next unless File.directory? folder
    folder = folder.split('/')[-1]

    create_structure_for(folder)
    generate_haml_for(folder)
    generate_sass_for(folder)
  end
end

def create_structure_for(folder)
  return if File.directory? "../web_root/#{folder}/"

  FileUtils::mkdir_p "../web_root/#{folder}/"
  FileUtils::mkdir_p "../web_root/#{folder}/css/"
end

if __FILE__==$0
  generate_files
end
