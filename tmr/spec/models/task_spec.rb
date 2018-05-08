require 'rails_helper'

describe Task do

  let(:valid_params) {FactoryBot.build(:task_attributes)}

  before(:each) do
    FactoryBot.create(:task_user)
  end

  describe '#生成' do

    let(:task) { Task.create! valid_params }

    it '生成されたタスク有効であること' do
      expect(task).to be_valid
    end

    it '指定したユーザIDでタスクが生成されること' do
      expect(task.user_id).to eq valid_params[:user_id]
    end

    it '指定したタイトルでタスクが生成されること' do
      expect(task.title).to eq valid_params[:title]
    end

    it '指定した説明文でタスクが生成されること' do
      expect(task.description).to eq valid_params[:description]
    end

    it '指定したステータスでタスクが生成されること' do
      expect(task.status).to eq valid_params[:status]
    end

    it '指定した優先度でタスクが生成されること' do
      expect(task.priority).to eq valid_params[:priority]
    end

    it '指定した期限でタスクが生成されること' do
      expect(task.due_date).to eq valid_params[:due_date]
    end

    it '指定した開始日でタスクが生成されること' do
      expect(task.start_date).to eq valid_params[:start_date]
    end

    it '指定した終了日でタスクが生成されること' do
      expect(task.finished_date).to eq valid_params[:finished_date]
    end
  end

  describe '#バリデーション' do
    it 'ユーザIDがないタスク' do
      task = Task.new valid_params.merge(user_id: nil)
      expect(task).not_to be_valid
      expect(task.errors[:user_id][0]).to eq I18n.t('activerecord.errors.messages.blank')
    end

    it 'タイトルがないタスク' do
      task = Task.new valid_params.merge(title: nil)
      expect(task).not_to be_valid
      expect(task.errors[:title][0]).to eq I18n.t('activerecord.errors.messages.blank')
    end

    it '説明文がないタスク' do
      task = Task.new valid_params.merge(description: nil)
      expect(task).not_to be_valid
      expect(task.errors[:description][0]).to eq I18n.t('activerecord.errors.messages.blank')
    end

    it 'ステータスがないタスク' do
      task = Task.new valid_params.merge(status: nil)
      expect(task).not_to be_valid
      expect(task.errors[:status][0]).to eq I18n.t('activerecord.errors.messages.blank')
    end

    it '優先度がないタスク' do
      task = Task.new valid_params.merge(priority: nil)
      expect(task).not_to be_valid
      expect(task.errors[:priority][0]).to eq I18n.t('activerecord.errors.messages.blank')
    end

    it 'タイトルがながいタスク' do
      long_title = '123456789012345678901234567890'
      task = Task.new valid_params.merge(title: long_title)
      expect(task).not_to be_valid
      expect(task.errors[:title][0]).to eq I18n.t('activerecord.errors.messages.too_long', count: Task::TITLE_MAXIMUM_LENGTH)
    end

    it '説明文がながいタスク' do
        long_description = '12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890'
        task = Task.new valid_params.merge(description: long_description)
        expect(task).not_to be_valid
        expect(task.errors[:description][0]).to eq I18n.t('activerecord.errors.messages.too_long', count: Task::DESCRIPTION_MAXIMUM_LENGTH)
    end
  end
end
