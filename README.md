# FFI Snap7

FFI Ruby wrapper for Snap7 (http://snap7.sourceforge.net/)

## Installation

Under Ubuntu 14.04 (the environment I tested, but may apply to others as well), perform the following steps:

1. Download and compile Snap7 (see according documentation)
2. Copy libsnap7.so to /usr/local/lib


Add this line to your application's Gemfile:

    gem 'ffi-snap7'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ffi-snap7


## Usage

See examples/

Server:

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

Startup:

    authbind --deep ./examples/server.rb



Client:

    client = Snap7::Client.new
    client.connect '127.0.0.1', 0, 2
    p client.db_read  1, 0, 4
    client.db_write 1, 0, 4, [7, 15, 31, 63]
    p client.db_read  1, 0, 4
    client.disconnect

Startup:

    ./examples/client.rb



## Contributing

1. Fork it ( https://github.com/arohr/ffi-snap7/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
