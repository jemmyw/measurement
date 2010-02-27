require File.join(File.dirname(__FILE__), '..', 'measurement')

class Weight < Measurement::Base
  base :grams, :suffix => 'kg'
  conversion 1000.0, :kilograms, :kg, :kgs, :suffix => 'kg'
  conversion 453.59236, :pounds, :pound, :lbs, :suffix => 'lbs'
  conversion 28.3495231, :ounces, :ounce, :oz, :suffix => 'oz'
  conversion 6350.29318, :stone, :st, :suffix => 'st'
end