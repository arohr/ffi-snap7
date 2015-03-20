#!/usr/bin/env ruby

require 'lib/ffi-snap7'

server = Snap7::Server.new
server.register_db 1, 16
server.register_db 2, 16
server.start
puts 'started'

run = true
trap('INT') do
  puts 'stopping'
  server.stop
  run = false
end

while run
  sleep 0.1
end
puts 'done'
