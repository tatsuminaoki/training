# frozen_string_literal: true

require 'rails_helper'

describe ValueObjects::Label, type: :model do
  let(:label_value) { 1 }
  describe '#initialize and #get_value' do
    it 'Return value correctly' do
      expect(described_class.new(label_value).get_value).to eq label_value
    end
  end

  describe '#get_list' do
    it 'Return label list correctly' do
      expect(described_class.get_list.count).to be > 1
    end
  end

  describe '#get_text' do
    it 'Return text correctly' do
      expect(described_class.new(label_value).get_text).to eq described_class.get_list[label_value]
    end
  end
end
