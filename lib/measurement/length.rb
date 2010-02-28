require File.join(File.dirname(__FILE__), '..', 'measurement')

# This class represents a Length measurement. The
# base units are metres. The available conversions
# are:
#
# * millimetres (mm)
# * centimetres (cm)
# * metres (m)
# * kilometres (km)
# * inches (")
# * feet (')
# * miles
# * hands
# * light_seconds
# * light_hours
#
# Example usage:
#
#   require 'measurement/length'
#   puts Length.parse('180.34cm').in_feet_and_inches => 5' 11"
#
class Length < Measurement::Base
  base :metre, :metres, :suffix => 'm', :group => :metric
  unit 1000, :kilometre, :kilometres, :km, :suffix => 'km', :group => :metric
  unit 0.01, :centimetre, :centimetres, :cm, :suffix => 'cm', :group => :metric
  unit 0.001, :millimetre, :mm, :suffix => 'mm', :group => :metric
  
  unit 0.0254, :inch, :inches, :suffix => '"', :group => :imperial
  unit 0.3048, :feet, :foot, :suffix => "'", :group => :imperial
  unit 1609.34, :mile, :miles, :suffix => ' miles', :group => :imperial
  unit 0.1016, :hand, :hands, :suffix => ' hands'
  
  unit 299792458, :light_seconds, :suffix => ' light seconds'
  unit 1079252848800, :light_hours, :suffix => ' light hours'
end