module Snap7

  class DataBlockRegistry
    attr_reader :dbs

    def initialize
      @dbs = {}
    end


    def add_variable(ident, address, data_type)
      db_addr, _, var_addr = address.partition('.')
      var = Snap7::Variable.new ident, var_addr, data_type
      db(db_addr).add_variable var
    end


    def find_variable(ident)
      each do |db|
        found_variable = db.variables.find { |var| var.ident == ident }
        return found_variable if found_variable
      end

      return nil
    end


    def db(db_addr)
      @dbs[db_addr] ||= Snap7::DataBlock.new(db_addr)
    end


    def each(&block)
      sorted_dbs.each &block
    end


    def sorted_dbs
      @dbs.values.sort { |a,b| a.number <=> b.number }
    end

  end

end
