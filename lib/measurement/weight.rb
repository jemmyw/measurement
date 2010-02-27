require File.join(File.dirname(__FILE__), '..', 'measurement')

class Weight < Measurement::Base
  base :grams, :suffix => 'g'
  unit 1000.0, :kilograms, :kg, :kgs, :suffix => 'kg'
  unit 453.59236, :pounds, :pound, :lbs, :suffix => 'lbs'
  unit 28.3495231, :ounces, :ounce, :oz, :suffix => 'oz'
  unit 6350.29318, :stone, :st, :suffix => 'st'
end