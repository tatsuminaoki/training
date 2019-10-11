require 'rails_helper'

RSpec.describe TaskLabel, type: :model do
  let(:email) { Faker::Internet.email }
  let(:password) { Faker::Internet.password(min_length: 8) }
  let(:user) { create(:user, email: email, password: password) }
  let!(:task) { create(:task, user_id: user.id) }
  let!(:label) { create(:label) }

  describe '#create' do
    context '有効な値で紐づく場合' do
      it '正常に生成される' do
        task_label = TaskLabel.new(task: task, label: label)
        task_label.valid?
        expect(task_label).to be_truthy
      end
    end

    context '同じ値でもう一回紐づく場合' do
      it '重複エラーが発生する' do
        task_label1 = TaskLabel.create(task: task, label: label)
        task_label2 = TaskLabel.new(task: task, label: label)
        task_label2.valid?
        expect(task_label2.errors.messages[:task_id]).to include "はすでに存在します"
      end
    end
  end

end
