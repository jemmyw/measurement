require 'spec_helper'

describe Measurement::Unit do
  describe '#instance methods' do
    before do
      @unit = Measurement::Unit.new(150.0, :test, :other)
    end
        
    describe '#from' do
      it 'should multiply the amount by the unit scale' do
        @unit.from(1).should == 150.0
      end
    end
  
    describe '#to' do
      it 'should divide the amount by the unit scale' do
        @unit.to(150).should == 1
      end
    end
  
    describe '#format' do
      it 'should return a string' do
        @unit.format(1).should be_a(String)
      end
      
      it 'should format using the given precision' do
        @unit.format(200,1).should == "1.3"
        @unit.format(200,2).should == "1.33"
      end
      
      it 'should remove the end 0' do
        @unit.format(255, 2).should == '1.7'
      end
      
      it 'should apply the suffix' do
        @unit = Measurement::Unit.new(150.0, :test, :suffix => 'test')
        @unit.format(150, 0).should == "1test"
      end
      
      it 'should apply the prefix' do
        @unit = Measurement::Unit.new(150.0, :test, :prefix => 'test')
        @unit.format(150, 0).should == "test1"
      end
    end
  end
end