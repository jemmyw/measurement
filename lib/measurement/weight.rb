require File.join(File.dirname(__FILE__), '..', 'measurement')

# This class represents a Weight measurement. The
# base units are grams. The available conversions
# are:
#
# * grams (g)
# * kilograms (kg)
# * pounds (lbs)
# * ounces (oz)
# * stone (st)
#
# Example usage:
#
#   require 'measurement/weight'
#   puts Length.parse('100kg').in_lbs_and_oz => 220lbs 7oz
#
class Weight < Measurement::Base
  base :gram, :grams, :suffix => 'g'
  unit 1000.0, :kilogram, :kilograms, :kg, :kgs, :suffix => 'kg'
  unit 453.59236, :pounds, :pound, :lbs, :suffix => 'lbs'
  unit 28.3495231, :ounces, :ounce, :oz, :suffix => 'oz'
  unit 6350.29318, :stone, :st, :suffix => 'st'
end