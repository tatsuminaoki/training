require 'rails_helper'

describe Task do
  describe '#生成' do
    before do
      @params = {
        title:'Test title',
        description:'Test description',
        status:1,
        priority:2,
        due_date:Date.new(2018, 4 ,16),
        start_date:Date.new(2018, 4 ,16),
        finished_date:Date.new(2018, 4 ,16)
      }
    end
    it '指定したタイトルでタスクが生成されること' do
      task = Task.new(@params)
      expect(task.title).to eq @params[:title]
    end
    it '指定した説明文でタスクが生成されること' do
      task = Task.new(@params)
      expect(task.description).to eq @params[:description]
    end
    it '指定したステータスでタスクが生成されること' do
      task = Task.new(@params)
      expect(task.status).to eq @params[:status]
    end
    it '指定した優先度でタスクが生成されること' do
      task = Task.new(@params)
      expect(task.priority).to eq @params[:priority]
    end
    it '指定した期限でタスクが生成されること' do
      task = Task.new(@params)
      expect(task.due_date).to eq @params[:due_date]
    end
    it '指定した開始日でタスクが生成されること' do
      task = Task.new(@params)
      expect(task.start_date).to eq @params[:start_date]
    end
    it '指定した終了日でタスクが生成されること' do
      task = Task.new(@params)
      expect(task.finished_date).to eq @params[:finished_date]
    end
  end
end
