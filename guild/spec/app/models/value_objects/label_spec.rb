require 'rails_helper'

describe ValueObjects::Label , type: :model do
  context '#initialize and #get_value' do
    it 'whether instance was created and whether expected value is returned' do
      value = 1
      label = ValueObjects::Label.new(value)
      expect(label.get_value).to eq value
    end
  end

  context '#get_list' do
    it 'whether list is returned' do
      list = ValueObjects::Label.get_list
      expect(list.count).to be > 1
    end
  end

  context '#get_text' do
    it 'whether list is returned' do
      value = 2
      label = ValueObjects::Label.new(value)
      list = ValueObjects::Label.get_list
      expect(label.get_text).to eq list[value]
    end
  end
end
