# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'タスクラベルモデルのテスト', type: :model do
  describe 'タスクラベル' do
    let!(:init_user) { create(:user) }
    let!(:label) { FactoryBot.build(:label) }
    let!(:task) { FactoryBot.create(:task) }
    context '存在するタスクID、ラベルIDであれば' do
      let(:task_label) { FactoryBot.create(:task_label, label_id: label.id, task_id: task.id) }
      it '有効であること' do
        expect(label).to be_valid
      end
    end
    context '存在しないタスクIDであれば' do
      let(:task_label) { FactoryBot.create(:task_label, label_id: label.id, task_id: task.id + 100) }
      it '無効な状態であること' do
        expect { task_label.valid? }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
    context '存在しないラベルIDであれば' do
      let(:task_label) { FactoryBot.create(:task_label, label_id: label.id + 100, task_id: task.id) }
      it '無効な状態であること' do
        expect { task_label.valid? }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
