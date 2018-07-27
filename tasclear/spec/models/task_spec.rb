# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'バリデーション' do
    let(:name) { 'ほげタスク' }
    let(:content) { 'ほげほげ' }
    let(:status) { 'doing' }
    let(:priority) { 'low' }
    subject { build(:task, name: name, content: content, status: status, priority: priority) }
    before do
      create(:user, id: 1)
    end

    context '有効' do
      context 'タスク名、内容、ステータス、パスワードが指定される' do
        it { is_expected.to be_valid }
      end

      context 'タスク名が20文字' do
        let(:name) { 'a' * 20 }
        it { is_expected.to be_valid }
      end

      context '内容が200文字' do
        let(:content) { 'a' * 200 }
        it { is_expected.to be_valid }
      end
    end

    context '無効' do
      context 'タスク名が指定されない' do
        let(:name) { '' }
        it { is_expected.to be_invalid }
      end

      context 'タスク名が21文字' do
        let(:name) { 'a' * 21 }
        it { is_expected.to be_invalid }
      end

      context '内容が201文字' do
        let(:content) { 'a' * 201 }
        it { is_expected.to be_invalid }
      end

      context 'ステータスがnil' do
        let(:status) { nil }
        it { is_expected.to be_invalid }
      end

      context '優先度がnil' do
        let(:status) { nil }
        it { is_expected.to be_invalid }
      end
    end
  end

  describe '#search_and_order' do
    before do
      @user = create(:user, id: 1)
      @task1 = create(:task, name: 'タスク１', status: 'to_do')
      @task2 = create(:task, name: 'タスク２', status: 'doing')
    end

    it 'タスク名で検索できること' do
      expect(Task.search_and_order({ search_name: 'タスク１' }, @user)).to include(@task1)
      expect(Task.search_and_order({ search_name: 'タスク１' }, @user)).not_to include(@task2)
    end

    it 'ステータスで検索できること' do
      expect(Task.search_and_order({ search_status: 'to_do' }, @user)).to include(@task1)
      expect(Task.search_and_order({ search_status: 'to_do' }, @user)).not_to include(@task2)
    end

    it 'タスク名・ステータスの両方で検索できること' do
      expect(Task.search_and_order({ search_name: 'タスク１', search_status: 'to_do' }, @user)).to include(@task1)
      expect(Task.search_and_order({ search_name: 'タスク１', search_status: 'to_do' }, @user)).not_to include(@task2)
    end
  end
end
