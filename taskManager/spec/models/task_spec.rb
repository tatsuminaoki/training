require 'rails_helper'

RSpec.describe Task, type: :model do

  let(:summary)     { 'task1' }
  let(:description) { 'this is 1st valid task' }
  let(:status)      { 1 }
  let(:priority)    { 1 }
  subject { Task.new(summary: summary, description: description, status: status, priority: priority )  }

  describe '#create' do
    describe 'validate summary' do
      context 'when max length' do
        let(:summary) { 'T' * 50 }
        it { is_expected.to be_valid }
      end

      context 'when over length' do
        let(:summary) { 'T' * 51 }
        it { expect(subject).to be_invalid }
      end

      context 'when null' do
        let(:summary) { nil }
        it { expect(subject).to be_invalid }
      end
    end

    describe 'validate description' do
      context 'when max length' do
        let(:description) { 'T' * 255 }
        it { is_expected.to be_valid }
      end

      context 'when over length' do
        let(:description) { 'T' * 256 }
        it { is_expected.to be_invalid }
      end

      context 'when null' do
        let(:description) { nil }
        it { is_expected.to be_valid }
      end
    end

    describe 'validate status' do
      context 'when valid value' do
        for i in 1..5
          let(:status) { i }
          it { is_expected.to be_valid }
        end
      end

      context 'when null' do
        let(:status) { nil }
        it { is_expected.to be_invalid }
      end
    end

    describe 'validate priority' do
      context 'when valid value' do
        for i in 1..5
          let(:priority) { i }
          it { is_expected.to be_valid }
        end
      end

      context 'when null' do
        let(:priority) { nil }
        it { is_expected.to be_invalid }
      end
    end
  end
end
