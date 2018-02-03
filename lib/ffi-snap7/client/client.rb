require 'ffi-snap7/client/wrapper'

module Snap7

  class Client

    # @return [Proc]
    # @see http://www.mikeperham.com/2010/02/24/the-trouble-with-ruby-finalizers/
    #
    def self.finalizer(ptr)
      proc do
        ptrptr = FFI::MemoryPointer.new :pointer
        ptrptr.write_pointer ptr
        Snap7.cli_destroy ptrptr
      end
    end


    def initialize
      @cli       = Snap7.cli_create
      @connected = false

      ObjectSpace.define_finalizer self, self.class.finalizer(@cli)
    end


    # @return [FFI::MemoryPointer] pointer to the native object
    def to_ptr
      @cli
    end


    def connect(address, rack, slot)
      check_rc Snap7.cli_connect_to(@cli, address, rack, slot)
      @connected = true
    end


    def disconnect
      Snap7.cli_disconnect @cli
      @connected = false
    end


    def connected?
      @connected
    end


    def set_session_password(password)
      check_rc Snap7.cli_set_session_password(@cli, password)
    end


    def plc_status
      p_status = FFI::MemoryPointer.new :uchar, 1
      check_rc Snap7.cli_get_plc_status(@cli, p_status)
      result = p_status.get_array_of_uint8 0, 1
      { 0 => 'unknown', 4 => 'stopped', 8 => 'running'}[result.first]
    end


    def db_read(db_number, start, size)
      p_usr_data = FFI::MemoryPointer.new :uchar, size
      check_rc Snap7.cli_db_read(@cli, db_number, start, size, p_usr_data)
      p_usr_data.get_array_of_uint8 0, size
    end


    def db_write(db_number, start, size, data)
      p_usr_data = FFI::MemoryPointer.new :uchar, size
      p_usr_data.put_array_of_uint8 0, data
      check_rc Snap7.cli_db_write(@cli, db_number, start, size, p_usr_data)
    end


    # @param port [Integer] remote port to connect to
    def remote_port=(port)
      p_value = FFI::MemoryPointer.new(:uint16)
      p_value.write_uint16 port
      check_rc Snap7.cli_set_param(@cli, P_u16_RemotePort, p_value)
    end


    # @return [Integer]
    def remote_port
      p_port = FFI::MemoryPointer.new(:uint16)
      check_rc Snap7.cli_get_param(@cli, P_u16_RemotePort, p_port)
      p_port.read_uint16
    end


    private


    def check_rc(rc)
      fail error_text(rc) unless rc == 0
    end


    def error_text(error)
      text_len = 1024
      text_ptr = FFI::MemoryPointer.new :char, text_len
      if Snap7.cli_error_text(error, text_ptr, text_len) == 0
        text_ptr.read_string
      else
        fail "Error getting error text for error no #{error}"
      end
    end


  end

end
