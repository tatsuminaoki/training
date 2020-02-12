# frozen_string_literal: true

require 'rails_helper'

describe ValueObjects::State, type: :model do
  let(:state_value) { 1 }
  describe '#initialize and #get_value' do
    it 'Return value correctly' do
      expect(described_class.new(state_value).get_value).to eq state_value
    end
  end

  describe '#get_list' do
    it 'Return state list correctly' do
      expect(described_class.get_list.count).to be > 1
    end
  end

  describe '#get_text' do
    it 'Return text correctly' do
      expect(described_class.new(state_value).get_text).to eq described_class.get_list[state_value]
    end
  end
end
