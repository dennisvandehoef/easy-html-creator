module Server
  # Map extensions to their content type
  CONTENT_TYPE_MAPPING = {
    'html' => 'text/html;charset=utf-8',
    'txt'  => 'text/plain;charset=utf-8',
    'png'  => 'image/png',
    'jpg'  => 'image/jpeg',
    'ico'  => 'image/x-icon',
    'js'   => 'text/javascript;charset=utf-8',
    'css'  => 'text/css;charset=utf-8',
    'php'  => 'text/html;charset=utf-8'
  }

  # Treat as binary data if content type cannot be found
  DEFAULT_CONTENT_TYPE = 'application/octet-stream'

  # This helper function parses the extension of the
  # requested file and then looks up its content type.

  class Response
    require 'time'

    def initialize(request)
      @request = request
      @socket  = request.socket
    end

    def print msg
      @socket.print msg
    end

    def send_404
      code    = '404 Not Found'
      message = "404: File '#{@request.path}' not found\n"
      Server.log "404: File not found #{@request.path}"

      send(code, message)
    end

    def content_type file
      ext = File.extname(file).split(".").last
      CONTENT_TYPE_MAPPING.fetch(ext, DEFAULT_CONTENT_TYPE)
    end

    def send_301 redirect_to
      redirect_to.slice!("web_root")
      redirect_to = "http://#{@socket.addr[2]}:#{@socket.addr[1]}#{redirect_to}"

      Server.log "301: redirect to #{redirect_to}"

      # respond with a 301 error code to redirect
      print "HTTP/1.1 301 Moved Permanently\r\n" +
             "Location: #{redirect_to}\r\n"+
             "Connection: Keep-Alive\r\n"
    end

    def send_file path
      last_modified = File.mtime(path).httpdate
      File.open(path, "rb") do |file|
        print "HTTP/1.1 200 OK\r\n" +
               "Content-Type: #{content_type(file)}\r\n" +
               "Content-Length: #{file.size}\r\n" +
               "Connection: Keep-Alive\r\n" +
               "Vary: Accept-Encoding\r\n" +
               "Last-Modified: #{last_modified}\r\n" +
               "Date: #{Date.today.httpdate}\r\n" +
               "Expires: #{Date.today.next_year.httpdate}\r\n" +
               "Cache-Control: max-age=31536000,public\r\n" +
               "\r\n"

        # write the contents of the file to the socket
        IO.copy_stream(file, @socket)
      end
    end

    def send(code, message, type='text/html')
      print "HTTP/1.1 #{code}\r\n" +
             "Content-Type: #{type}\r\n" +
             "Content-Length: #{message.size}\r\n" +
             "Connection: Keep-Alive\r\n" +
             "Vary: Accept-Encoding\r\n" +
             "\r\n" +
             message
    end
  end
end
