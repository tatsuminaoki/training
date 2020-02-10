require 'rails_helper'
require 'value_objects/state'
require 'value_objects/priority'
require 'value_objects/label'

RSpec.describe Task, type: :model do
  describe '#create' do
    describe 'columun:user_id' do
      let(:user_id) { 1 }
      subject { Task.new(user_id: user_id) }
      context 'Valid value' do
        it 'Create correctly' do
            expect(subject).not_to be_valid
            expect(subject.errors[:user_id].count).to eq 0
        end
      end
      context 'Nil value' do
        let(:user_id) { nil }
        it 'User_id is nil' do
            expect(subject).not_to be_valid
            expect(subject.errors[:user_id][0]).to eq I18n.t(:errors)[:messages][:blank]
        end
      end
      context 'Invalid value' do
        let(:user_id) { 'test' }
        it 'User_id is not numerical' do
            expect(subject).not_to be_valid
            expect(subject.errors[:user_id][0]).to eq I18n.t(:errors)[:messages][:not_a_number]
        end
      end
    end
    describe 'Columun:subject' do
      let(:input_subject) { 'test' }
      subject { Task.new(subject: input_subject) }
      context 'Valid value' do
        it 'Create correctly' do
            expect(subject).not_to be_valid
            expect(subject.errors[:subject].count).to eq 0
        end
      end
      context 'Invalid value' do
        let(:input_subject) { nil }
        it 'Subject is nil' do
            expect(subject).not_to be_valid
            expect(subject.errors[:subject][0]).to eq I18n.t(:errors)[:messages][:blank]
        end
      end
    end
    describe 'Columun:state' do
      let(:state) { 1 }
      subject { Task.new(state: state) }
      context 'Valid value' do
        it 'Create correctly' do
            expect(subject).not_to be_valid
            expect(subject.errors[:state].count).to eq 0
        end
      end
      context 'Nil value' do
        let(:state) { nil }
        it 'State is nil' do
            expect(subject).not_to be_valid
            expect(subject.errors[:state][0]).to eq I18n.t(:errors)[:messages][:blank]
        end
      end
      context 'Invalid value' do
        let(:state) { ValueObjects::State.get_list.count + 1 }
        it 'State is invalid' do
            expect(subject).not_to be_valid
            expect(subject.errors[:state][0]).to eq I18n.t(:errors)[:messages][:inclusion]
        end
      end
    end
    describe 'Columun:priority' do
      let(:priority) { 1 }
      subject { Task.new(priority: priority) }
      context 'Valid value' do
        it 'Create correctly' do
            expect(subject).not_to be_valid
            expect(subject.errors[:priority].count).to eq 0
        end
      end
      context 'Invalid value' do
        let(:priority) { nil }
        it 'Priority is nil' do
            expect(subject).not_to be_valid
            expect(subject.errors[:priority][0]).to eq I18n.t(:errors)[:messages][:blank]
        end
      end
      context 'Invalid value' do
        let(:priority) { ValueObjects::Priority.get_list.count + 1 }
        it 'Priority is invalid' do
            expect(subject).not_to be_valid
            expect(subject.errors[:priority][0]).to eq I18n.t(:errors)[:messages][:inclusion]
        end
      end
    end
    describe 'Columun:label' do
      let(:label) { 1 }
      subject { Task.new(label: label) }
      context 'Valid value' do
        it 'Create correctly' do
            expect(subject).not_to be_valid
            expect(subject.errors[:label].count).to eq 0
        end
      end
      context 'Nil value' do
        let(:label) { nil }
        it 'Label is nil' do
            expect(subject).not_to be_valid
            expect(subject.errors[:label][0]).to eq I18n.t(:errors)[:messages][:blank]
        end
      end
      context 'Invalid value' do
        let(:label) { ValueObjects::Label.get_list.count + 1 }
        it 'Label is invalid' do
            expect(subject).not_to be_valid
            expect(subject.errors[:label][0]).to eq I18n.t(:errors)[:messages][:inclusion]
        end
      end
    end
  end
end
