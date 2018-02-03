require 'ffi-snap7/server/wrapper'

module Snap7

  class Server

    S7AreaPE = 0
    S7AreaPA = 1
    S7AreaMK = 2
    S7AreaCT = 3
    S7AreaTM = 4
    S7AreaDB = 5


    # @return [Proc]
    # @see http://www.mikeperham.com/2010/02/24/the-trouble-with-ruby-finalizers/
    #
    def self.finalizer(ptr)
      proc do
        ptrptr = FFI::MemoryPointer.new :pointer
        ptrptr.write_pointer ptr
        Snap7.srv_destroy ptrptr
      end
    end


    def initialize
      @srv = Snap7.srv_create

      ObjectSpace.define_finalizer self, self.class.finalizer(@srv)
    end


    # @return [FFI::MemoryPointer] pointer to the native object
    def to_ptr
      @srv
    end


    def start
      check_rc Snap7.srv_start(@srv)
    end


    def stop
      check_rc Snap7.srv_stop(@srv)
    end


    def register_area(area_code, index, size)
      p_usr_data = FFI::MemoryPointer.new :uchar, size
      check_rc Snap7.srv_register_area @srv, area_code, index, p_usr_data, size
    end


    def register_db(index, size)
      register_area S7AreaDB, index, size
    end


    # @param port [Integer] local port to bind to
    def local_port=(port)
      p_port = FFI::MemoryPointer.new(:uint16)
      p_port.write_uint16 port
      check_rc Snap7.srv_set_param(@srv, P_u16_LocalPort, p_port)
    end


    # @return [Integer]
    def local_port
      p_port = FFI::MemoryPointer.new(:uint16)
      check_rc Snap7.srv_get_param(@srv, P_u16_LocalPort, p_port)
      p_port.read_uint16
    end


    private


    def check_rc(rc)
      fail error_text(rc) unless rc == 0
    end


    def error_text(error)
      text_len = 1024
      text_ptr = FFI::MemoryPointer.new :char, text_len
      if Snap7.srv_error_text(error, text_ptr, text_len) == 0
        text_ptr.read_string
      else
        fail "Error getting error text for error no #{error}"
      end
    end

  end

end

