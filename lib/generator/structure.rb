require 'rubygems'
require 'fileutils'

module Generator
  class Structure
    def generate path
      create_structure_for path
      copy_public_content path
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
  end
end



