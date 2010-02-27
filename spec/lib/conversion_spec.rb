require 'spec_helper'

describe Measurement::Conversion do
  describe '#instance methods' do
    before do
      @conversion = Measurement::Conversion.new(150.0, :test, :other)
    end
        
    describe '#from' do
      it 'should multiply the amount by the conversion scale' do
        @conversion.from(1).should == 150.0
      end
    end
  
    describe '#to' do
      it 'should divide the amount by the conversion scale' do
        @conversion.to(150).should == 1
      end
    end
  
    describe '#format' do
      it 'should return a string' do
        @conversion.format(1).should be_a(String)
      end
      
      it 'should format using the given precision' do
        @conversion.format(200,1).should == "1.3"
        @conversion.format(200,2).should == "1.33"
      end
      
      it 'should apply the suffix' do
        @conversion = Measurement::Conversion.new(150.0, :test, :suffix => 'test')
        @conversion.format(150, 0).should == "1test"
      end
      
      it 'should apply the prefix' do
        @conversion = Measurement::Conversion.new(150.0, :test, :prefix => 'test')
        @conversion.format(150, 0).should == "test1"
      end
    end
  end
end