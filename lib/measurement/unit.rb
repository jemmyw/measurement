module Measurement
  class Unit
    include Comparable
    
    attr_reader :names, :scale, :groups
    
    def initialize(scale, *args)
      @options = args.last.is_a?(Hash) ? args.pop : {}
      @names = args
      @scale = scale
      @groups = [@options[:group]].flatten
    end
    
    def <=>(anOther)
      scale <=> anOther.scale
    end
    
    def has_name?(name)
      names.include?(name)
    end
    
    def in_group?(group)
      groups.include?(group.to_sym)
    end
  
    def from(amount)
      amount.to_f * @scale
    end
  
    def to(amount)
      amount.to_f / @scale
    end
  
    def format(amount, precision = 2)
      number = ("%.#{precision}f" % to(amount)).sub(/(\.\d*)0/, '\1')
      prefix + number + suffix
    end
  
    def prefix
      @options[:prefix] || ''
    end
  
    def suffix
      @options[:suffix] || ''
    end
  end
end