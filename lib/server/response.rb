module Server
  # Map extensions to their content type
  CONTENT_TYPE_MAPPING = {
    'html' => 'text/html',
    'txt'  => 'text/plain',
    'png'  => 'image/png',
    'jpg'  => 'image/jpeg',
    'ico'  => 'image/x-icon',
    'js'   => 'text/javascript',
    'css'  => 'text/css',
    'php'  => 'text/html'
  }

  # Treat as binary data if content type cannot be found
  DEFAULT_CONTENT_TYPE = 'application/octet-stream'

  # This helper function parses the extension of the
  # requested file and then looks up its content type.

  class Response
    def initialize(request, server)
      @request = request
      @socket  = request.socket
      @server  = server
    end

    def log msg
      @server.log msg
    end

    def print msg
      @socket.print msg
    end

    def send_404
      code    = 404
      message = "404: File '#{@request.path}' not found\n"
      log "404: File not found #{@request.path}"

      send(code, message)
    end

    def content_type file
      ext = File.extname(file).split(".").last
      CONTENT_TYPE_MAPPING.fetch(ext, DEFAULT_CONTENT_TYPE)
    end

    def send_301 redirect_to
      redirect_to.slice!("web_root")
      redirect_to = "http://#{@socket.addr[2]}:#{@socket.addr[1]}#{redirect_to}"

      log "301: redirect to #{redirect_to}"

      # respond with a 301 error code to redirect
      print "HTTP/1.1 301 Moved Permanently\r\n" +
             "Location: #{redirect_to}\r\n"+
             "Connection: close\r\n"
    end

    def send_file path
      File.open(@request.path, "rb") do |file|
        print "HTTP/1.1 200 OK\r\n" +
               "Content-Type: #{content_type(file)}\r\n" +
               "Content-Length: #{file.size}\r\n" +
               "Connection: close\r\n" +
               "\r\n"

        # write the contents of the file to the socket
        IO.copy_stream(file, @socket)
      end
    end

    def send(code, message)
      print "HTTP/1.1 #{code} Not Found\r\n" +
             "Content-Type: text/plain\r\n" +
             "Content-Length: #{message.size}\r\n" +
             "Connection: close\r\n" +
             "\r\n" +
             message
    end
  end
end
