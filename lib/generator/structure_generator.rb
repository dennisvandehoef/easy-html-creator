require 'fileutils'

module Generator
  class StructureGenerator
    def generate(input_folder, output_folder)
      return if File.directory? output_folder

      FileUtils::mkdir_p output_folder
      do_bower_if_available(input_folder)
      copy_public_content(input_folder, output_folder)
      FileUtils::mkdir_p "#{output_folder}/css/"
      FileUtils::mkdir_p "#{output_folder}/js/"
    end

    def copy_public_content(input_folder, output_folder)
      src_dir  = "#{input_folder}/public"
      return unless File.directory? src_dir

      FileUtils::copy_entry(src_dir, output_folder)
    end

    def do_bower_if_available(input_folder)
      bower_file  = "#{input_folder}/public/bower.json"
      return unless File.exists? bower_file

      cmd = "cd #{input_folder}/public && bower install"
      cmd = "if which bower >/dev/null; then #{cmd}; else echo 'please install bower http://bower.io/'; fi"
      puts %x[ #{cmd} ]
    end
  end
end

