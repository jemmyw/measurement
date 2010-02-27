require File.join(File.dirname(__FILE__), 'measurement', 'unit')

module Measurement
  class NoUnitFoundException < Exception; end

  # The Measurement::Base class provides a basis for types of
  # measurement. For example, length or weight. It should
  # be subclassed and not used directly.
  #
  # Example:
  #
  #   class Length < Measurement::Base
  #     base :metres, :suffix => 'm'
  #     unit 0.3048, :feet, :foot, :suffix => "'"
  #   end
  #   
  #   Length.new(10).in_feet => 32.8083989501312
  #
  class Base
    # Define the base measurement unit. This method accepts
    # a list of names for the base measurement, followed
    # by the standard unit options. See #unit
    #
    # Example, defining a base unit for weights:
    #
    #   class Weight < Measurement::Base
    #     base :grams, :suffix => 'g'
    #   end
    #
    #   Weight.new(1).to_s => "1g"
    #
    def self.base(*args)
      if args.any?
        @base = Unit.new(1.0, *args)
        add_unit(@base)
      else
        @base
      end
    end
    
    def self.units # :nodoc:
      @units ||= []
    end
  
    # Define a unit of measurement. This must be a number based on
    # the #base measurement unit.
    # Takes a scaling number, a list of names and finally a
    # hash of options.
    #
    # For example, if the base unit is metres, then defining the
    # unit for centimetres would be as follows:
    #
    #   unit 0.01, :centimetre, :centimetres, :cm, :suffix => 'cm'
    #
    # Here a centimetre is defined as one hundredth of a metre. The
    # different name usages for centimetre are specified (for parsing, see #parse),
    # and the suffix is set to 'cm'
    #
    # Available options:
    #
    # * <tt>prefix</tt> - A prefix to use when formatting the unit.
    # * <tt>suffix</tt> - A suffix to use when formatting the unit.
    #
    def self.unit(scale, *args)
      add_unit(Unit.new(scale, *args))
    end
  
    def self.add_unit(unit) # :nodoc:
      units << unit
    end
  
    def self.fetch_scale(scale = nil) # :nodoc:
      scale.nil? ? base : units.detect do |unit|
        unit.has_name?(scale)
      end
    end
    
    def self.find_scale(scale) # :nodoc:
      units.detect do |unit|
        unit.has_name?(scale) ||
          unit.suffix == scale
      end
    end
  
    def self.from(amount, scale) # :nodoc:
      fetch_scale(scale).from(amount)
    end
  
    def self.to(amount, scale = nil) # :nodoc:
      fetch_scale(scale).to(amount)
    end
  
    def self.format(amount, scale = nil, precision = 2) #:nodoc:
      fetch_scale(scale).format(amount, precision)
    end
    
    # Parse a string containing this measurement. The string
    # can use any of the defined units
    def self.parse(string)
      string = string.dup
      base_amount = 0.0
      
      while string =~ /(\d+(\.\d+)?)([^\d]*)/
        amount = $1.to_f
        scale = $3 && $3.strip
        
        if scale && scale.length > 0
          scale = find_scale(scale)
          
          if scale.nil?
            raise NoUnitFoundException.new(scale)
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
      if method.to_s =~ /^(as|in)_(.*)/
        scale = $2
        if scale =~ /and/
          to_s(scale, *args)
        else
          as(scale.to_sym, *args)
        end
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
    alias_method :format, :to_s
  end
end