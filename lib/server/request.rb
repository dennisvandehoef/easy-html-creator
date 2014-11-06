require 'uri'

module Server
  class Request
    attr_reader :request, :socket

    def initialize(socket)
      @request = socket.gets
      @socket  = socket
    end

    def uri
      @request.split(" ")[1]
    end

    def params
      @params ||= CGI::parse(URI(uri).query)
    end

    def path
      clean = []

      # Split the path into components
      parts = original_path.split("/")

      parts.each do |part|
        # skip any empty or current directory (".") path components
        next if part.empty? || part == '.'
        # If the path component goes up one directory level (".."),
        # remove the last clean component.
        # Otherwise, add the component to the Array of clean components
        part == '..' ? clean.pop : clean << part
      end

      # return the web root joined to the clean path
      File.join(Dispatcher::WEB_ROOT, *clean)
    end

    def original_path
      URI.unescape(URI(uri).path)
    end

    def to_s
      @request
    end

    def empty?
      return @request ? false : true
    end
  end
end
