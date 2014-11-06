#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'
require 'fileutils'

require_relative 'generate_haml.rb'
require_relative 'generate_sass.rb'
require_relative 'generate_coffeeScript.rb'

def generate_files
  FileUtils.rm_rf(Dir.glob("web_root/*"))

  Dir.glob('dev_root/*').select do |folder|
    next unless File.directory? folder
    next if folder.include? 'shared'
    folder = folder.split('/')[-1]

    create_structure_for(folder)
    generate_haml_for(folder)
    generate_sass_for(folder)
    generate_coffee_for(folder)
  end
end

def create_structure_for(folder)
  return if File.directory? "web_root/#{folder}/"

  FileUtils::mkdir_p "web_root/#{folder}/"
  copy_public_content(folder)
  FileUtils::mkdir_p "web_root/#{folder}/css/"
  FileUtils::mkdir_p "web_root/#{folder}/js/"
end

def copy_public_content(folder)
  src_dir  = "dev_root/#{folder}/public"
  dest_dir = "web_root/#{folder}"
  return unless File.directory? src_dir

  FileUtils::copy_entry(src_dir, dest_dir)
end

if __FILE__==$0
  generate_files
end
