module Measurement
  # This class is a group of units. To specify that a unit
  # is in a group pass the group option to Measurement::Base#unit
  class UnitGroup
    def initialize(units)
      @units = units.sort.reverse
    end
    
    def format(amount, precision = 0)
      units = @units.dup
      strs = []
      
      while unit = units.shift
        n_in = unit.to(amount)
        n_in = n_in.floor unless units.empty?
        n_out = unit.from(n_in)
        amount -= n_out
        strs << unit.format(n_out, precision) unless n_out == 0
      end
      
      strs.join(' ')
    end
  end
end