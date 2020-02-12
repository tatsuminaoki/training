require "rails_helper"

describe ValueObjects::Priority, type: :model do
  let(:priority_value) { 1 }
  describe "#initialize and #get_value" do
    it "Return value correctly" do
      expect(described_class.new(priority_value).get_value).to eq priority_value
    end
  end

  describe "#get_list" do
    it "Return priority list correctly" do
      expect(described_class.get_list.count).to be > 1
    end
  end

  describe "#get_text" do
    it "Return text correctly" do
      expect(described_class.new(priority_value).get_text).to eq described_class.get_list[priority_value]
    end
  end
end
