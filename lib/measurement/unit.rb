module Measurement
  class Unit
    attr_reader :names
    
    def initialize(scale, *args)
      @options = args.last.is_a?(Hash) ? args.pop : {}
      @names = args
      @scale = scale
    end
    
    def has_name?(name)
      names.include?(name)
    end
  
    def from(amount)
      amount.to_f * @scale
    end
  
    def to(amount)
      amount.to_f / @scale
    end
  
    def format(amount, precision = 2)
      prefix + ("%.#{precision}f" % to(amount)) + suffix
    end
  
    def prefix
      @options[:prefix] || ''
    end
  
    def suffix
      @options[:suffix] || ''
    end
  end
end