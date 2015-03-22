require_relative 'base.rb'

module Generator
  class BowerGenerator < Generator::Base
    def generate(input_folder, output_folder)
      bower_file = "#{input_folder}/public/bower.json"
      return unless File.exists? bower_file
      compile_file(bower_file)
    end

    def compile(bower_file, *args)
      input_folder = File.dirname(bower_file)

      cmd = "cd #{input_folder} && bower install"
      cmd = "if which bower >/dev/null; then echo '\e[32m->running bower\e[0m' && #{cmd}; else echo '\e[31mplease install bower \"npm install -g bower\" http://bower.io/ \e[0m'; fi"
      puts %x[ #{cmd} ]
    end
  end
end

