require_relative '../generator/generator.rb'

module Server
  class Dispatcher
    WEB_ROOT = 'web_root'

    def execute_php(path, params)
      params_s = ''
      params.each do |key, value|
        params_s+=key+'='+value[0]+' '
      end
      executors = ['php', 'php-cgi', 'php-fpm']
      cmd = "#{executors[0]} #{path} #{params_s}"
      STDERR.puts(cmd)
      %x[ #{cmd} ]
    end

    def regenerate_files_if(path, server)
      return unless path.include? '.html'

      #no html? no reload -> no regenarate
      server.log "#######################"
      server.log "#                     #"
      server.log "#   Renew all files   #"
      server.log "#                     #"
      server.log "#######################"
      Generator::Generator.new.generate
    end

    def dispatch(request, response, server)
      path = request.path
      server.log path

      regenerate_files_if(path, server)
      # Make sure the file exists and is not a directory
      # before attempting to open it.
      if File.exist?(path) && !File.directory?(path)
        if path.include? '.php'
          response.send(200, execute_php(path, request.params))
        else
          response.send_file path
        end
      elsif File.exist?(path) && File.directory?(path)
        path = "#{path}/index.html"
        if File.exist?(path) && !File.directory?(path)
          response.send_301 path
        else
          response.send_404
        end
      else
        response.send_404
      end
    end
  end
end
