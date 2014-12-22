require_relative 'server/server.rb'
require_relative 'server/dispatcher.rb'

# for 'rake start'
options = $options || {port: 5678, ip: '127.0.0.1'}

server = Server::Server.new Server::Dispatcher.new

server.listen options[:port], options[:ip]
