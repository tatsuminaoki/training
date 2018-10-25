require 'rails_helper'

RSpec.describe TaskLabel, type: :model do
  describe 'タスクラベル登録テスト' do
    let(:label) { FactoryBot.create(:label) }
    let(:task) { FactoryBot.create(:task) }
    before do
      FactoryBot.create(:user, id: 1)
    end
    subject { task_label.valid? }
    context '登録テスト' do
      let(:task_label) { FactoryBot.create(:task_label, label_id: label.id, task_id: task.id) }
      it "存在するタスクID、ラベルIDでであれば有効な状態であること" do
        is_expected.to be_truthy
      end
    end
    context '存在しないタスクIDでの登録' do
      let(:task_label) { FactoryBot.create(:task_label, label_id: label.id, task_id: task.id + 100) }
      it "存在しないタスクIDであれば無効な状態であること" do
        expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
    context '存在しないラベルIDでの登録' do
      let(:task_label) { FactoryBot.create(:task_label, label_id: label.id + 100, task_id: task.id) }
      it "存在しないラベルIDであれば無効な状態であること" do
        expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
