require_relative 'base.rb'

module Generator
  class BowerGenerator < Generator::Base
    def generate(input_folder, output_folder)
      bower_file = "#{input_folder}/bower.json"
      return unless File.exists? bower_file
      compile_file(bower_file)
    end

    def compile(bower_file, *args)
      input_folder = File.dirname(bower_file)

      cmd = "cd #{input_folder} && bower install"
      cmd = "if which bower >/dev/null; then #{cmd}; else echo 'please install bower http://bower.io/'; fi"
      puts %x[ #{cmd} ]
    end
  end
end

