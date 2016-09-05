module Snap7

  class DataBlock
    attr_reader :number, :variables

    def initialize(db_addr)
      @number    = db_addr.scan(/\d+/).first.to_i
      @variables = []
    end


    def add_variable(var)
      var.db = self
      @variables << var
    end


    def size
      last_var = @variables.sort { |a,b| a.byte <=> b.byte }.last
      last_var.byte + last_var.byte_size
    end


    def decode(data)
      @variables.map do |var|
        {
          :ident   => var.ident,
          :address => var.address,
          :value   => var.decode(data)
        }
      end
    end

  end

end

