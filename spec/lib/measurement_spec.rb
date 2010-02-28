require 'spec_helper'

describe Measurement::Base do
  describe '::base' do
    it 'should define to_measurement on Fixnum and Float' do
      Length
      1.to_length.should be_a(Length)
      1.to_length.to_f.should == 1.0
      1.5.to_length.should be_a(Length)
      1.5.to_length.to_f.should == 1.5
    end
    
    it 'should define to_measurement on String' do
      Length
      "10cm".to_length.should be_a(Length)
      "10cm".to_length.to_s(:metre, 1).should == "0.1m"
    end
  end
  
  describe '::find_scale' do
    it 'should be able to find the unit by name' do
      Weight.find_scale(:kilogram).should_not be_nil
      Weight.find_scale(:kilogram).has_name?(:kilogram).should be_true
    end
    it 'should be able to find the unit if the name passed is a string' do
      Weight.find_scale("kilogram").should_not be_nil
      Weight.find_scale(:kilogram).has_name?(:kilogram).should be_true
    end
    it 'should be able to find the unit by suffix' do
      Weight.unit 2000, :quit, :qt, :suffix => 'q'
      Weight.find_scale('q').should_not be_nil
    end
    it 'should return nil if no unit is found' do
      Weight.find_scale('gigboot').should be_nil
    end
  end
  
  describe '::parse' do
    it 'should parse in the base unit if no unit is specified' do
      Length.parse('113').to_f.should == 113.0
    end
    
    it 'should parse floating point numbers' do
      Length.parse('113.43').to_f.should == 113.43
    end
    
    it 'should parse in the unit specified' do
      Length.parse('32cm').to_f.should == 0.32
      Length.parse('32cm').to_s(:cm, 0).should == '32cm'
    end
    
    it 'should parse multiple units' do
      Length.parse('32cm 5mm').to_f.should == 0.325
      Length.parse('32cm 5mm').to_s(:cm, 0).should == '32cm'
      Length.parse('32cm 5mm').to_s(:cm_and_mm).should == '32cm 5mm'
    end
    
    it 'should be able to parse units based on their suffix' do
      Length.parse('5"').in_inches.should == 5.0
      Length.parse(%Q{5' 11"}).to_f.should == 1.8034
    end
    
    it 'should raise a NoScaleFoundException if there is no scale matching the one passed' do
      lambda do
        Length.parse('10giglygoops')
      end.should raise_error(Measurement::NoUnitFoundException)
    end
  end
  
  describe 'operators' do
    before do
      @length_1 = Length.new(1)
      @length_2 = Length.new(2)
    end
    
    %w(+ - / *).each do |operator|
      it 'should return a new object of the same type' do
        @length_1.send(operator, @length_2).should be_a(Length)
      end
      
      it 'should perform the operator' do
        @value = @length_1.to_f.send(operator, @length_2.to_f)
        @length_1.send(operator, @length_2).to_f.should == @value
      end
    end
  end
  
  describe '#<=>' do
    it 'should return the difference between the objects' do
      (Length.new(1) <=> Length.new(2)).should == (1.0 <=> 2.0)
    end
  end
  
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