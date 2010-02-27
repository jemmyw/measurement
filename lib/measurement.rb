module Measurement
  class Conversion
    def initialize(unit, scale, *args)
      @options = args.last.is_a?(Hash) ? args.pop : {}
      @names = args
      @scale = scale
      @unit = unit
    
      @names.each do |name|
        @unit.add_conversion(name, self)
      end
    
      define_methods
    end
  
    def define_methods
      @names.each do |name|
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
  
    def convert(amount)
      amount.to_f / @scale
    end
  
    def format(amount, precision = 2)
      prefix + ("%.#{precision}f" % convert(amount)) + suffix
    end
  
    private
  
    def prefix
      @options[:prefix] || ''
    end
  
    def suffix
      @options[:suffix] || ''
    end
  end


  class Base
    @@conversions = {}
  
    def self.base(*args)
      @@base = Conversion.new(self, 1.0, *args)
    end
  
    def self.conversion(scale, *args)
      Conversion.new(self, scale, *args)
    end
  
    def self.add_conversion(name, conversion)
      @@conversions[name] = conversion
    end
  
    def self.fetch_scale(scale = nil)
      scale ? @@conversions[scale] : @@base
    end
  
    def self.from(amount, scale)
      fetch_scale(scale).from(amount)
    end
  
    def self.convert(amount, scale = nil)
      fetch_scale(scale).convert(amount)
    end
  
    def self.format(amount, scale = nil, precision = 2)
      fetch_scale(scale).format(amount, precision)
    end
  
    def initialize(amount = 0, scale = nil)
      @amount = self.class.from(amount, scale)
    end
  
    def to_i
      @amount.to_i
    end
  
    def to_f
      @amount.to_f
    end
  
    def as(scale)
      self.class.convert(@amount, scale)
    end
  
    def to_s(scale = nil, precision = 2)
      if scale.to_s =~ /_and_/
        scales = scale.to_s.split('_and_')
        amount = @amount
        strs = []
    
        while scale = scales.shift
          n_in = self.class.convert(amount, scale.to_sym)
          n_in = n_in.floor unless scales.empty?        
          n_out = self.class.from(n_in, scale.to_sym)
          amount -= self.class.from(n_in, scale.to_sym)
          strs << self.class.format(n_out, scale.to_sym, 0)
        end
    
        strs.join(' ')
      else
        self.class.format(@amount, scale, precision)
      end
    end
  end
end