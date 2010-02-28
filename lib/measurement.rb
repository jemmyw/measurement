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
  #     base :metre, :metres, :suffix => 'm'
  #     unit 0.3048, :feet, :foot, :suffix => "'"
  #   end
  #   
  #   Length.new(10).in_feet => 32.8083989501312
  #
  # Extending an existing measurement:
  #
  # Length.unit 2000, :quint, :qt, :suffix => 'qt'
  # Length.new(10).to_s(:qt, 3) => 0.005qt
  #
  class Base
    include Comparable
    
    # Define the base measurement unit. This method accepts
    # a list of names for the base measurement, followed
    # by the standard unit options. See #unit
    #
    # Example, defining a base unit for weights:
    #
    #   class Weight < Measurement::Base
    #     base :gram, :grams, :suffix => 'g'
    #   end
    #
    #   Weight.new(1).to_s => "1g"
    #
    # The base unit should only be set once because all
    # other units in this measurement are based off the
    # base unit.
    #
    def self.base(*args)
      if args.any? || !@base
        @base = Unit.new(1.0, *args)
        add_unit(@base)
        register_measurement
      else
        @base
      end
    end
    
    def self.register_measurement
      method_name = name.gsub(/\s/, '_').gsub(/.[A-Z]/) do |s|
        s[0,1] + '_' + s[1,1].downcase
      end.downcase
      
      [Fixnum, Float].each do |klass|
        klass.class_eval %Q{
        def to_#{method_name}
          #{name}.new(self)
        end}
      end
      
      String.class_eval %Q{
        def to_#{method_name}
          #{name}.parse(self)
        end}
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
    def self.unit(unit, *args)
      add_unit(Unit.new(unit, *args))
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
  
    def self.from(amount, unit) # :nodoc:
      fetch_scale(unit).from(amount)
    end
  
    def self.to(amount, unit = nil) # :nodoc:
      fetch_scale(unit).to(amount)
    end
  
    def self.format(amount, unit = nil, precision = 2) #:nodoc:
      fetch_scale(unit).format(amount, precision)
    end
    
    # Parse a string containing this measurement. The string
    # can use any of the defined units. This function will look
    # for numbers in the string, followed by text. The text
    # can be any unit name or suffix.
    #
    # Examples:
    #   Length.parse("180cm").in_cm => 180
    #   Length.parse("10m 11cm 12mm").in_metres => 10.122
    #
    # If a valid unit cannot be found an error is raised:
    #
    #   Weight.parse("180cm") => Measurement::NoUnitException
    #
    def self.parse(string)
      string = string.dup
      base_amount = 0.0
      
      while string =~ /(\d+(\.\d+)?)([^\d]*)/
        amount = $1.to_f
        unit = $3 && $3.strip
        
        if unit && unit.length > 0
          unit = find_scale(unit)
          
          if unit.nil?
            raise NoUnitFoundException.new(unit)
          else
            base_amount += unit.from(amount)
          end
        else
          base_amount += amount
        end
        
        string.sub!(/(\d+(\.\d+)?)([^\d]*)/, '')
      end
      
      self.new(base_amount)
    end
  
    def initialize(amount = 0, unit = nil)
      @amount = self.class.from(amount, unit)
    end
  
    # The base unit as an integer
    def to_i
      @amount.to_i
    end
  
    # The base unit as a float
    def to_f
      @amount.to_f
    end
    
    def <=>(anOther)
      to_f <=> anOther.to_f
    end
    
    %w(+ - / *).each do |operator|
      class_eval %Q{
        def #{operator}(anOther)
          self.class.new(self.to_f #{operator} anOther.to_f)
        end
      }
    end
  
    # This measurement converted to the specified unit.
    #
    # Example:
    #
    #   Length.new(10).as(:feet) => 32.8083989501312
    #
    # This method can also be called using helper methods:
    #
    #   Length.new(10).in_feet
    #   Length.new(10).as_feet
    #
    def as(unit)
      self.class.to(@amount, unit)
    end
    
    def method_missing(method, *args) # :nodoc:
      if method.to_s =~ /^(as|in)_(.*)/
        unit = $2
        if unit =~ /and/
          to_s(unit, *args)
        else
          as(unit.to_sym, *args)
        end
      else
        super
      end
    end
  
    # Format the measurement and return as a string. 
    # This will format using the base unit if no unit
    # is specified.
    #
    # Example:
    #
    #   Length.new(1.8034).to_s(:feet) => 6'
    #
    # Multiple units can be specified allowing for a
    # more naturally formatted measurement. For example:
    #
    #   Length.new(1.8034).to_s(:feet_and_inches) => 5' 11"
    #
    # Naturally formatted measurements can be returned using
    # shorthand functions:
    #
    #   Length.new(1.8034).in_feet_and_inches => 5' 11"
    #
    # A precision can be specified, otherwise the measurement
    # is rounded to the nearest integer.
    def to_s(unit = nil, precision = 0)
      if unit.to_s =~ /_and_/
        units = unit.to_s.split('_and_')
        amount = @amount
        strs = []
    
        while unit = units.shift
          n_in = self.class.to(amount, unit.to_sym)
          n_in = n_in.floor unless units.empty?        
          n_out = self.class.from(n_in, unit.to_sym)
          amount -= self.class.from(n_in, unit.to_sym)
          strs << self.class.format(n_out, unit.to_sym, 0)
        end
    
        strs.join(' ')
      else
        self.class.format(@amount, unit, precision)
      end
    end
    alias_method :format, :to_s
  end
end