require 'rails_helper'

describe ValueObjects::Priority , type: :model do
  context '#initialize and #get_value' do
    it 'whether instance was created and whether expected value is returned' do
      value = 1
      priority = ValueObjects::Priority.new(value)
      expect(priority.get_value).to eq value
    end
  end

  context '#get_list' do
    it 'whether list is returned' do
      priority = ValueObjects::Priority.get_list
      expect(priority.count).to be > 1
    end
  end

  context '#get_text' do
    it 'whether list is returned' do
      value = 2
      priority = ValueObjects::Priority.new(value)
      list = ValueObjects::Priority.get_list
      expect(priority.get_text).to eq list[value]
    end
  end
end
