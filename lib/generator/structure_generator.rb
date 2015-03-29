require 'fileutils'
require_relative 'base.rb'

module Generator
  class StructureGenerator < Generator::Base
    def generate(input_folder, output_folder)
      unless File.directory? output_folder
        FileUtils::mkdir_p output_folder
        FileUtils::mkdir_p "#{output_folder}/css/"
        FileUtils::mkdir_p "#{output_folder}/js/"
      end

      copy_public_content(input_folder, output_folder)
    end

    def copy_public_content(input_folder, output_folder)
      src_dir  = "#{input_folder}/public"

      FileUtils::copy_entry(src_dir, output_folder) if File.directory? src_dir
    end

  end
end
