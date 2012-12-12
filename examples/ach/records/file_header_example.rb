require 'example_helper'

describe ACH::Records::FileHeader do
  before(:each) do
    @header = ACH::Records::FileHeader.new
    @header.immediate_destination_name = 'destination'
    @header.immediate_destination = '123456789'
    @header.immediate_origin_name = 'origin'
    @header.immediate_origin = '123456789'
  end

  describe '#to_ach' do
    it 'has 94 characters' do
      @header.to_ach.should have(94).characters
    end
  end

  describe '#immediate_origin_to_ach' do
    it 'adds a leading space when only 9 digits' do
      @header.immediate_origin_to_ach.should == ' 123456789'
    end

    it 'does not add a leading space when 10 digits' do
      @header.immediate_origin = '1234567890'
      @header.immediate_origin_to_ach.should == '1234567890'
    end
  end

  describe '#immediate_origin_to_ach' do
    it 'adds a leading space when only 9 digits' do
      @header.immediate_destination_to_ach.should == ' 123456789'
    end

    it 'does not add a leading space when 10 digits' do
      @header.immediate_destination = '1234567890'
      @header.immediate_destination_to_ach.should == '1234567890'
    end
  end
end
