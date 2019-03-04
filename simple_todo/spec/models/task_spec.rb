require 'rails_helper'

RSpec.describe Task, type: :model do

  describe 'validations' do
    before(:each) do
      create(:user)
    end

    it 'valid if task has all required contents' do
      task = create(:task)
      expect(task).to be_valid
    end

    it 'invalid if one or more required contents are missing' do
      task = Task.new(
        title: '',
        description: '',
        user_id: '',
        status: '',
        limit: '2019-03-28 12:29:00'
      )
      expect(task).to be_invalid
    end

    it 'valid if title length is 40' do
      task = build(:task, title: 'a'*40)
      expect(task).to be_valid
    end

    it 'invalid if title is too long' do
      task = build(:task, title: 'a'*41)
      expect(task).to be_invalid
    end

    it 'valid if description length is 200' do
      task = build(:task, description: 'a'*200)
      expect(task).to be_valid
    end

    it 'invalid if description is too long' do
      task = build(:task, description: 'a'*201)
      expect(task).to be_invalid
    end

    it 'valid if task limit is future' do
      task = build(:task, limit: '2019-03-28 12:29:00')
      expect(task).to be_valid
    end

    it 'invalid if task limit is past' do
      task = build(:task, limit: Date.today - 1)
      expect(task).to be_invalid
    end
  end

  describe 'title_search(title)' do
    before(:each) do
      create(:user)
      create(:task, title: 'test title 1')
      create(:task, title: 'test title 2')
    end
    context 'search with title:null' do
      it 'displays all tasks' do
        expect(Task.title_search(nil).size).to eq 2
      end
    end

    context 'search with title: 1' do
      it 'displays 1 task' do
        expect(Task.title_search('1').size).to eq 1
      end
    end

    context 'search with title: 3' do
      it 'displays 0 task' do
        expect(Task.title_search('3').size).to eq 0
      end
    end
  end

  describe 'status_search(status)' do
    before(:each) do
      create(:user)
      create(:task, title: 'test title 0',status:0)
      create(:task, title: 'test title 1',status:1)
      create(:task, title: 'test title 2',status:1)
    end

    context 'search with status: 1' do
      it 'displays 2 tasks' do
        expect(Task.status_search('1').size).to eq 2
      end
    end

    context 'search with status: 3' do
      it 'displays 0 task' do
        expect(Task.status_search('3').size).to eq 0
      end
    end
  end

  describe 'user-task relation' do
    let(:user) { create(:user, name: 'test user', email: 'test@test.com') }
    let(:task) { create(:task, title: 'test title 0', user_id: user.id ) }

    context 'get task with user data' do
      it 'get user name' do
        expect(task.user.name).to eq 'test user'
        expect(task.user.email).to eq 'test@test.com'
      end
    end
  end
end
