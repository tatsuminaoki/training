require 'rails_helper'

RSpec.describe 'Task', type: :model do
  describe '検索機能' do
    before do
      create(:task, name: 'English', status: 0)
      create(:task, name: 'Science', status: 0)
      create(:task, name: 'English', status: 1)
      create(:task, name: 'Science', status: 1)
    end
    context '検索した時' do
      it '検索したタスク名と同じものを表示する' do
        expect(Task.all.sort_and_search({ name: 'English' }).count).to eq 2
      end
      it '未着手のタスクを表示する' do
        expect(Task.all.sort_and_search({ status: 0 }).count).to eq 2
      end
      it '検索したタスク名と同じもので着手のタスクを表示する' do
        expect(Task.all.sort_and_search({ name: 'Science', status: 1 }).count).to eq 1
      end
    end
  end
end