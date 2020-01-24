require 'rails_helper'

describe ValueObjects::State , type: :model do
  context '#initialize and #get_value' do
    it 'whether instance was created and whether expected value is returned' do
      value = 1
      state = ValueObjects::State.new(value)
      expect(state.get_value).to eq value
    end
  end

  context '#get_list' do
    it 'whether list is returned' do
      list = ValueObjects::State.get_list
      expect(list.count).to be > 1
    end
  end

  context '#get_text' do
    it 'whether list is returned' do
      value = 2
      state = ValueObjects::State.new(value)
      list = ValueObjects::State.get_list
      expect(state.get_text).to eq list[value]
    end
  end
end
