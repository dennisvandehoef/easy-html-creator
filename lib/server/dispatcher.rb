require_relative '../generator/generator.rb'

module Server
  class Dispatcher
    WEB_ROOT = 'web_root'
    DEV_ROOT = 'dev_root'

    def dispatch(request, response, server)
      path = request.path

      regenerate_files_if(path, server)

      return response.send_404 unless File.exist?(path)

      if !File.directory?(path)
        if path.include? '.php'
          response.send(200, execute_php(path, request.params))
        else
          response.send_file path
        end
      else
        if File.exist?("#{path}/index.html")
          response.send_301 "#{path}/index.html"
        else
          response.send(200, list_dir(path, server))
        end
      end
    end

    def list_dir(path, server)
      content = ''
      Dir.glob("#{path.gsub(WEB_ROOT, DEV_ROOT)}/*/").each do |f|
        f = f.gsub(DEV_ROOT, WEB_ROOT)

        regenerate_files_if("#{f}index.html", server)

        f_name = File.basename(f)
        f_path = "#{path}/#{f_name}".sub("#{WEB_ROOT}/", '')
        content += "<li><a href='#{f_path}'>#{f_name}</a></li>" if File.directory?(path)
      end

      "<!DOCTYPE html><html><head><body><h1>#{path}</h1><ul>#{content}</ul><a target='_blank' href='https://github.com/dennisvandehoef/easy-html-creator'>ehc on Github</a></body></html>"
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

    def execute_php(path, params)
      params_s = ''
      params.each do |key, value|
        params_s += "#{key}=#{value[0]} "
      end
      executors = ['php', 'php-cgi', 'php-fpm']
      cmd = "#{executors[0]} #{path} #{params_s}"
      STDERR.puts(cmd)
      %x[ #{cmd} ]
    end
  end
end
