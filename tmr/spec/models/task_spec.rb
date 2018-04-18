require 'rails_helper'

describe Task do
  describe '#生成' do
    let(:params) {{
      user_id:1,
      title:'Test title',
      description:'Test description',
      status:1,
      priority:2,
      due_date:Time.new(2018, 4 , 16) + 2.days,
      start_date:Time.new(2018, 4 , 16) - 1.day,
      finished_date:Time.new(2018, 4 , 16)
    }}
    let(:task) { Task.create! params }

    it '指定したユーザIDでタスクが生成されること' do
      expect(task.user_id).to eq params[:user_id]
    end
    it '指定したタイトルでタスクが生成されること' do
      expect(task.title).to eq params[:title]
    end
    it '指定した説明文でタスクが生成されること' do
      expect(task.description).to eq params[:description]
    end
    it '指定したステータスでタスクが生成されること' do
      expect(task.status).to eq params[:status]
    end
    it '指定した優先度でタスクが生成されること' do
      expect(task.priority).to eq params[:priority]
    end
    it '指定した期限でタスクが生成されること' do
      expect(task.due_date).to eq params[:due_date]
    end
    it '指定した開始日でタスクが生成されること' do
      expect(task.start_date).to eq params[:start_date]
    end
    it '指定した終了日でタスクが生成されること' do
      expect(task.finished_date).to eq params[:finished_date]
    end
  end
end
