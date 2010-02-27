require 'spec_helper'

describe Length do
  describe '::parse' do
    it 'should parse in the base unit if no unit is specified' do
      Length.parse('113').to_f.should == 113.0
    end
    
    it 'should parse floating point numbers' do
      Length.parse('113.43').to_f.should == 113.43
    end
    
    it 'should parse in the unit specified' do
      Length.parse('32cm').to_f.should == 0.32
      Length.parse('32cm').to_s(:cm).should == '32cm'
    end
    
    it 'should parse multiple units' do
      Length.parse('32cm 5mm').to_f.should == 0.325
      Length.parse('32cm 5mm').to_s(:cm, 0).should == '33cm'
      Length.parse('32cm 5mm').to_s(:cm_and_mm).should == '32cm 5mm'
    end
    
    it 'should be able to parse units based on their suffix' do
      Length.parse('5"').in_inches.should == 5.0
      Length.parse(%Q{5' 11"}).to_f.should == 1.8034
    end
    
    it 'should raise a NoScaleFoundException if there is no scale matching the one passed' do
      lambda do
        Length.parse('10giglygoops')
      end.should raise_error(Measurement::NoScaleFoundException)
    end
  end
end