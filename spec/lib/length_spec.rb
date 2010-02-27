require 'spec_helper'

describe Length do
  it 'should have 10 conversions' do
    Length.conversions.size.should == 10
  end
  
  it 'should use metres as a base' do
    Length.new(1).to_s(nil, 0).should == '1m'
  end
  
  { :cm => 100,
    :mm => 1000,
    :inches => 39.370,
    :feet => 3.281,
    :hand => 9.842,
    :km => 0.001
  }.each do |key, value|
    it "should have #{key} with 1 metre = #{value} #{key}" do
      Length.new(1).as(key).should be_close(value, 0.001)
    end
  end
  
  it 'should have miles' do
    Length.new(1).in_miles.should be_close(0.0006213, 0.0000001)
  end
end