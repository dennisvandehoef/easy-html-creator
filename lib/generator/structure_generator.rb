require 'find'
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

      #cannot use copy_entry or cp_r with symbolic existent links in target
      #FileUtils::copy_entry(src_dir, output_folder, true, false, true) if File.directory? src_dir
      Find.find(src_dir) do |source|
        target = source.sub(/^#{src_dir}/, output_folder)
        if File.directory? source
          FileUtils.mkdir target unless File.exists? target
        else
          FileUtils.copy source, target
        end
      end

    end
  end
end
