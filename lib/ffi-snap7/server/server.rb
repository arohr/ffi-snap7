require 'lib/ffi-snap7/server/wrapper'

module Snap7

  class Server

    S7AreaPE = 0
    S7AreaPA = 1
    S7AreaMK = 2
    S7AreaCT = 3
    S7AreaTM = 4
    S7AreaDB = 5


    def initialize
      @srv = Snap7.srv_create
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


    private


    def check_rc(rc)
      fail error_text(rc) unless rc == 0
    end


    def error_text(error)
      text_len = 1024
      text_ptr = FFI::MemoryPointer.new :pointer, text_len
      if Snap7.srv_error_text(error, text_ptr, text_len) == 0
        text_ptr.read_string
      else
        fail "Error getting error text for error no #{error}"
      end
    end

  end

end

