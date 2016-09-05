module Snap7

  class Variable
    attr_reader :ident, :byte, :bit, :type
    attr_accessor :db


    def initialize(ident, address, type)
      addr_parts = address.scan(/\d+/)

      if address =~ /^DBX/
        fail "Invalid bit address '#{address}'" unless addr_parts.size == 2
      end

      @ident   = ident
      @address = address
      @byte    = addr_parts.first.to_i
      @bit     = addr_parts.last.to_i if addr_parts.size == 2
      @type    = type
    end


    def bit_size
      case @address
      when /^DBD/ # double (32 bit)
        32
      when /^DBW/ # word   (16 bit)
        16
      when /^DBB/ # byte   (8 bit)
        8
      when /^DBX/ # bit    (1 bit)
        1
      else
        fail "Invalid address '#{@address}' of variable #{@ident}. Cannot determine size."
      end
    end


    def byte_size
      @byte_size ||= (bit_size / 8.0).ceil
    end


    def address
      ["DB#{db.number}", @address].compact.join('.')
    end


    def decode(data)
      var_data = data[byte, byte_size]

      case @type
      when :bool
        var_data.first[@bit] > 0

      when :int8
        var_data.pack('C1').unpack('c').first

      when :uint8
        var_data.pack('C1').unpack('C').first

      when :int16
        var_data.reverse.pack('C2').unpack('s').first

      when :uint16
        var_data.reverse.pack('C2').unpack('S').first

      when :int32
        var_data.reverse.pack('C4').unpack('l').first

      when :uint32
        var_data.reverse.pack('C4').unpack('L').first

      when :float32
        var_data.reverse.pack('C4').unpack('f').first

      else
        fail "Invalid type '#{@type}' of variable #{@ident}. Cannot decode data."
      end
    end


    def encode(value)
      case @type
      when :int8, :uint8
        [value]

      when :int16, :uint16
        [value].pack('s').unpack('C2').reverse

      when :int32, :uint32
        [value].pack('l').unpack('C4').reverse

      when :float32
        [value].pack('f').unpack('C4').reverse

      else
        fail "Invalid type '#{@type}' of variable #{@ident}. Cannot encode data."
      end
    end

  end

end