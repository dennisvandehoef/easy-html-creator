require_relative '../generator/generator.rb'

module Server
  class Dispatcher
    WEB_ROOT = 'web_root'
    DEV_ROOT = 'dev_root'

    def initialize
      @generator = Generator::Generator.new
      Dir.mkdir(WEB_ROOT) unless File.exist?(WEB_ROOT)
    end

    def dispatch(request, response)
      path = request.path

      regenerate_files_if(path)

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
          response.send(200, list_dir(path))
        end
      end
    end

    def list_dir(path)
      content = ''

      Dir.glob("#{path.gsub(WEB_ROOT, DEV_ROOT)}/*/*.haml").each do |f|
        next if f.include? 'layout.haml'
        f = File.path(f)
        f_name = File.basename(f).gsub('.haml', '.html')
        f_path = File.dirname(f).sub("#{DEV_ROOT}", '')
        content += "<li><a href='#{f_path}/#{f_name}'><b>#{f_path}</b>/#{f_name}</a></li>"
      end

       Dir.glob("#{path.gsub(WEB_ROOT, DEV_ROOT)}/*/public/*.html").each do |f|
        f = File.path(f)
        f_name = File.basename(f)
        f_path = File.dirname(f).sub('/public', '').sub("#{DEV_ROOT}", '')
        puts f_path
        content += "<li><a href='#{f_path}/#{f_name}'><b>#{f_path}</b>/#{f_name}</a></li>"
      end

      "<!DOCTYPE html><html><head><style>*{ font-size: 20px; font-family: Verdana, 'Lucida Sans Unicode', sans-serif;} a,a:hover{text-decoration: none; color: #818181;}</style></head><body><h1>#{path}</h1><ul>#{content}</ul><a target='_blank' href='https://github.com/dennisvandehoef/easy-html-creator'>ehc on Github</a></body></html>"
    end

    def regenerate_files_if(path)
      #TODO we only generate sass and coffee if its a haml file
      return unless path.include? '.html'

      #no html? no reload -> no regenarate
      Server.log "#######################"
      Server.log "#                     #"
      Server.log "#   Renew all files   #"
      Server.log "#                     #"
      Server.log "#######################"

      @generator.generate path.gsub("#{WEB_ROOT}", "#{DEV_ROOT}").gsub('.html', '.haml')
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
