require 'rails_helper'

describe ValueObjects::Label , type: :model do
  describe '#initialize and #get_value' do
    it 'Return correctly value' do
      value = 1
      expect(described_class.new(value).get_value).to eq value
    end
  end

  describe '#get_list' do
    it 'Return correctly list' do
      expect(described_class.get_list.count).to be > 1
    end
  end

  describe '#get_text' do
    it 'Return correctly text' do
      value = 2
      expect(described_class.new(value).get_text).to eq described_class.get_list[value]
    end
  end
end
