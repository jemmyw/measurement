require File.join(File.dirname(__FILE__), '..', 'measurement')

class Length < Measurement::Base
  base :metre, :suffix => 'm'
  conversion 1000, :kilometre, :kilometres, :km, :suffix => 'km'
  conversion 0.01, :centimetre, :centimetres, :cm, :suffix => 'cm'
  conversion 0.001, :millimetre, :mm, :suffix => 'mm'
  
  conversion 0.0254, :inch, :inches, :suffix => '"'
  conversion 0.3048, :feet, :foot, :suffix => "'"
  conversion 1609.34, :mile, :miles, :suffix => ' miles'
  conversion 0.1016, :hand, :hands, :suffix => ' hands'
  
  conversion 299792458, :light_seconds, :suffix => ' light seconds'
  conversion 1079252848800, :light_hours, :suffix => ' light hours'
end