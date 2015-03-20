#!/usr/bin/env ruby

require 'rubygems'
require 'ffi-snap7'

  client = Snap7::Client.new
  client.connect '127.0.0.1', 0, 2
p client.db_read  1, 0, 4
  client.db_write 1, 0, 4, [7, 15, 31, 63]
p client.db_read  1, 0, 4
  client.disconnect

