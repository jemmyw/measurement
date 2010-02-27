require File.join(File.dirname(__FILE__), '..', 'measurement')

class Length < Measurement::Base
  base :metre, :suffix => 'm'
  unit 1000, :kilometre, :kilometres, :km, :suffix => 'km'
  unit 0.01, :centimetre, :centimetres, :cm, :suffix => 'cm'
  unit 0.001, :millimetre, :mm, :suffix => 'mm'
  
  unit 0.0254, :inch, :inches, :suffix => '"'
  unit 0.3048, :feet, :foot, :suffix => "'"
  unit 1609.34, :mile, :miles, :suffix => ' miles'
  unit 0.1016, :hand, :hands, :suffix => ' hands'
  
  unit 299792458, :light_seconds, :suffix => ' light seconds'
  unit 1079252848800, :light_hours, :suffix => ' light hours'
end