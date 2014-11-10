require_relative 'server/server.rb'
require_relative 'server/dispatcher.rb'

server = Server::Server.new Server::Dispatcher.new

host   = ARGV[0] || '127.0.0.1'
port   = ARGV[1] || '5678'

server.listen port, host
