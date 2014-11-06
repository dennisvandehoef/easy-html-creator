require_relative 'server/server.rb'
require_relative 'server/dispatcher.rb'

server = Server::Server.new Server::Dispatcher.new

server.listen 5678
