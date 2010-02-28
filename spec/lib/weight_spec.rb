require 'spec_helper'

describe Weight do
  it 'should use grams as a base' do
    Weight.new(1).to_s(nil, 0).should == '1g'
  end
end