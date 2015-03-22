require 'socket'

require_relative 'request.rb'
require_relative 'response.rb'

module Server
  class Server
    def initialize(dispatcher)
      @dispatcher = dispatcher
    end

    def listen(port, host)
      server = TCPServer.new(host, port)
      Server.log "Server bound to http://#{host}:#{port}"

      loop do
        socket       = server.accept
        request      = Request.new socket
        response     = Response.new request

        next if request.empty?
        Server.log request.inspect

        begin
          @dispatcher.dispatch(request, response, self)
        rescue Exception => e
          msg = "#{e.backtrace.first}: #{e.message} (#{e.class})", e.backtrace.drop(1).map{|s| "\t#{s}"}
          Server.log msg
          socket.print '<pre style="max-width: 100%; color: red; width: 100%; font-size:20px; white-space: normal;">'

          socket.print msg.join("<br>")
          socket.print '</pre>'
        end

        socket.close
      end
    end

    def self.log msg
      STDERR.puts msg
    end
  end
end
