require "rails_helper"

RSpec.describe Maintenance, type: :model do
  describe "#create" do
    describe "columun:start_at" do
      context "Valid value" do
        it "Create·correctly" do
          maintenance = described_class.new(start_at: Time.now.ago(1.days).to_s, end_at: Time.now.to_s)
          maintenance.valid?
          expect(maintenance.errors[:start_at].count).to eq 0
        end
      end
      context "Invalid value" do
        it "Start_at is nil" do
          maintenance = described_class.new(end_at: Time.now.to_s)
          maintenance.valid?
          expect(maintenance.errors[:start_at][0]).to eq I18n.t(:errors)[:messages][:blank]
        end
      end
    end
    describe "columun:end_at" do
      context "Valid value" do
        it "Create·correctly" do
          maintenance = described_class.new(start_at: Time.now.ago(1.days).to_s, end_at: Time.now.to_s)
          maintenance.valid?
          expect(maintenance.errors[:end_at].count).to eq 0
        end
      end
      context "Invalid value" do
        it "End_at is nil" do
          maintenance = described_class.new(start_at: Time.now.to_s)
          maintenance.valid?
          expect(maintenance.errors[:end_at][0]).to eq I18n.t(:errors)[:messages][:blank]
        end
        it "End_at is older than start_at" do
          maintenance = described_class.new(start_at: Time.now.to_s, end_at: Time.now.yesterday.to_s)
          maintenance.valid?
          expect(maintenance.errors[:end_at][0]).to eq "Invalid value"
        end
      end
    end
  end
end
