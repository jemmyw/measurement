require 'spec_helper'

describe Measurement::Base do
  describe '#method_missing' do
    it 'should call as if passed in_scale' do
      Length.new(10).in_cm.should == Length.new(10).as(:cm)
    end
    
    it 'should call as if passed as_scale' do
      Length.new(10).as_cm.should == Length.new(10).as(:cm)
    end
    
    it 'should call to_s if passed in_scale_and_another_scale' do
      length = Length.new(123.52390842)
      length.in_cm_and_mm.should == length.to_s(:cm_and_mm)
    end
  end
end