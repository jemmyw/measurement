module Measurement
  class Conversion
    attr_reader :names
    
    def initialize(unit, scale, *args)
      @options = args.last.is_a?(Hash) ? args.pop : {}
      @names = args
      @scale = scale
      @unit = unit
    
      names.each do |name|
        @unit.add_conversion(name, self)
      end
    
      define_methods
    end
  
    def define_methods
      names.each do |name|
        @unit.class_eval %Q{
          def in_#{name}
            as(:#{name})
          end
        
          def as_#{name}
            as(:#{name})
          end
        }
      end
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
  
    private
  
    def prefix
      @options[:prefix] || ''
    end
  
    def suffix
      @options[:suffix] || ''
    end
  end
end