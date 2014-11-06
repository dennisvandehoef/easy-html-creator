require 'socket'
require 'uri'
require_relative 'generate.rb'

# Files will be served from this directory
WEB_ROOT = 'web_root'

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

def content_type(path)
  ext = File.extname(path).split(".").last
  CONTENT_TYPE_MAPPING.fetch(ext, DEFAULT_CONTENT_TYPE)
end

# This helper function parses the Request-Line and
# generates a path to a file on the server.

def requested_file(request_line)
  request_uri  = request_line.split(" ")[1]
  path         = URI.unescape(URI(request_uri).path)

  clean = []

  # Split the path into components
  parts = path.split("/")

  parts.each do |part|
    # skip any empty or current directory (".") path components
    next if part.empty? || part == '.'
    # If the path component goes up one directory level (".."),
    # remove the last clean component.
    # Otherwise, add the component to the Array of clean components
    part == '..' ? clean.pop : clean << part
  end

  # return the web root joined to the clean path
  File.join(WEB_ROOT, *clean)
end

def respond_with_file(path, socket)
  File.open(path, "rb") do |file|
    socket.print "HTTP/1.1 200 OK\r\n" +
                 "Content-Type: #{content_type(file)}\r\n" +
                 "Content-Length: #{file.size}\r\n" +
                 "Connection: close\r\n"

    socket.print "\r\n"

    # write the contents of the file to the socket
    IO.copy_stream(file, socket)
  end
end

def execute_php path
  executors = ['php', 'php-cgi', 'php-fpm']

  cmd = "#{executors[0]} #{path}"
  %x[ #{cmd} ]
end

def respond_with_php(path, socket)
  content = execute_php path

  socket.print "HTTP/1.1 200 OK\r\n" +
               "Content-Type: #{content_type(path)}\r\n" +
               "Content-Length: #{content.size}\r\n" +
               "Connection: close\r\n"

  socket.print "\r\n"
  socket.print content
end

def respond_with_404(path, socket)
  message = "404: File '#{path}' not found\n"
  log "404: File not found #{path}"

  # respond with a 404 error code to indicate the file does not exist
  socket.print "HTTP/1.1 404 Not Found\r\n" +
               "Content-Type: text/plain\r\n" +
               "Content-Length: #{message.size}\r\n" +
               "Connection: close\r\n"

  socket.print "\r\n"

  socket.print message
end

def respond_with_301(path, socket)
  path.slice!("web_root")
  redirect_to = "http://#{socket.addr[2]}:#{socket.addr[1]}#{path}"

  log "301: redirect to #{redirect_to}"

  # respond with a 301 error code to redirect
  socket.print "HTTP/1.1 301 Moved Permanently\r\n" +
               "Location: #{redirect_to}\r\n"+
               "Connection: close\r\n"
end

def regenerate_files(path)
  if path.include? '.html'
    #no html? no reload -> no regenarate
    log "Renew all files"

    begin
      generate_files
    rescue Exception => e
      msg = "#{e.backtrace.first}: #{e.message} (#{e.class})", e.backtrace.drop(1).map{|s| "\t#{s}"}
      socket.print '<pre style="max-width: 100%; color: red; width: 100%; font-size:20px; white-space: normal;">'
      socket.print msg
      socket.print '</pre>'
      log msg
    end
  end
end

def response_to_client(path, socket)
  log path

  regenerate_files(path)

  # Make sure the file exists and is not a directory
  # before attempting to open it.
  if File.exist?(path) && !File.directory?(path)
    if path.include? '.php'
      respond_with_php(path, socket)
    else
      respond_with_file(path, socket)
    end
  elsif File.exist?(path) && File.directory?(path)
    log "404: File not found #{path}"

    path = "#{path}/index.html"
    if File.exist?(path) && !File.directory?(path)
      respond_with_301(path, socket)
    else
      respond_with_404(path, socket)
    end

  else
    respond_with_404(path, socket)
  end

end

def log msg
  STDERR.puts msg
end

# Except where noted below, the general approach of
# handling requests and generating responses is
# similar to that of the "Hello World" example
# shown earlier.

portnumber = 5678

server = TCPServer.new('127.0.0.1', portnumber)

log "Server binded to http://127.0.0.1:#{portnumber}"

loop do
  socket       = server.accept
  request_line = socket.gets

  log request_line
  next unless request_line

  path = requested_file(request_line)

  response_to_client(path, socket)

  socket.close
end

