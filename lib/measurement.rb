require File.join(File.dirname(__FILE__), 'measurement', 'conversion')

module Measurement
  class NoScaleFoundException < Exception; end
  
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
    
    def self.find_scale(scale)
      
    end
  
    def self.from(amount, scale)
      fetch_scale(scale).from(amount)
    end
  
    def self.to(amount, scale = nil)
      fetch_scale(scale).to(amount)
    end
  
    def self.format(amount, scale = nil, precision = 2)
      fetch_scale(scale).format(amount, precision)
    end
    
    def self.parse(string)
      string = string.dup
      base_amount = 0.0
      
      while string =~ /(\d+(\.\d+)?)([^\d]*)/
        amount = $1.to_f
        scale = $3 && $3.strip
        
        if scale && scale.length > 0
          scale = find_scale(scale)
          
          if scale.nil?
            raise NoScaleFoundException.new(scale)
          else
            base_amount += scale.from(amount)
          end
        else
          base_amount += amount
        end
        
        string.sub!(/(\d+(\.\d+)?)([^\d]*)/, '')
      end
      
      self.new(base_amount)
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
      self.class.to(@amount, scale)
    end
    
    def method_missing(method, *args)
      if method.to_s =~ /and/ && method.to_s =~ /(as|in)_(.*)/
        to_s($2, *args)
      else
        super
      end
    end
  
    def to_s(scale = nil, precision = 2)
      if scale.to_s =~ /_and_/
        scales = scale.to_s.split('_and_')
        amount = @amount
        strs = []
    
        while scale = scales.shift
          n_in = self.class.to(amount, scale.to_sym)
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