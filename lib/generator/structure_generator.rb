require 'fileutils'

module Generator
  class StructureGenerator
    def generate input_folder, output_folder
      return if File.directory? output_folder

      FileUtils::mkdir_p output_folder
      copy_public_content(input_folder, output_folder)
      FileUtils::mkdir_p "#{output_folder}/css/"
      FileUtils::mkdir_p "#{output_folder}/js/"
    end

    def copy_public_content input_folder, output_folder
      src_dir  = "#{input_folder}/public"
      return unless File.directory? src_dir

      FileUtils::copy_entry(src_dir, output_folder)
    end
  end
end



