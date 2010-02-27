require File.join(File.dirname(__FILE__), 'measurement')

class Length < Measurement::Base
  base :cm, :suffix => 'cm'
  conversion 100.0, :metre, :suffix => 'm'
  conversion 0.1, :millimetre, :mm, :suffix => 'mm'
  conversion 2.54, :inch, :inches, :suffix => '"'
  conversion 30.48, :feet, :foot, :suffix => "'"
end