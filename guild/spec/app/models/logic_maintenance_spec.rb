# frozen_string_literal: true

require 'rails_helper'

describe LogicMaintenance, type: :model do
  let!(:maintenance_a) { create(:maintenance1) }
  describe '#register' do
    context 'Valid paramater' do
      it 'Be registered correctly' do
        start_at = Time.now.ago(2.days).to_s
        end_at   = Time.now.ago(1.day).to_s

        result = described_class.register(start_at, end_at)
        expect(result).to be true

        maintenance = Maintenance.first
        expect(maintenance.start_at).to eq start_at
        expect(maintenance.end_at).to eq end_at
      end
    end
    context 'Invalid paramater' do
      it 'Paramater is not datetime string' do
        expect(described_class.register('test', 'test')).to be false
      end
      it 'Start and End the same' do
        expect(described_class.register(Time.now.to_s, Time.now.to_s)).to be false
      end
    end
  end

  describe '#doing?' do
    it 'Return true correctly' do
      expect(described_class.doing?).to be true
    end
    it 'Return false correctly' do
      described_class.register(Time.now.ago(3.days).to_s, Time.now.ago(2.days).to_s)
      expect(described_class.doing?).to be false
    end
  end
end
