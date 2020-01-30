require 'rails_helper'

RSpec.describe Task, :type => :model do
  let(:user1) { User.create(name: 'John', email: 'user1@example.com', password: 'u1password') }
  describe 'Title validation when creates' do
    let(:task) { Task.new(params) }
    let(:params) { { title: title, user_id: user1.id } }
    subject { task }

    context 'title not presence' do
      let(:title) { '' }
      it {
        task.save
        is_expected.to be_invalid
      }
    end

    context 'title length is more than 50' do
      let(:title) { 'a' * 51 }
      it {
        task.save
        is_expected.to be_invalid
      }
    end

    context 'title presence and length is less than 50' do
      let(:title) { 'a' * 50 }
      it {
        task.save
        is_expected.to be_valid
      }
    end
  end

  describe 'Title validation when edits' do
    let(:task) { Task.create(title: 'base title', user_id: user1.id) }
    subject { task }

    context 'title not presence' do
      it {
        task.update(title: '')
        is_expected.to be_invalid
      }
    end

    context 'title length is more than 50' do
      it {
        task.update(title: 'a' * 51)
        is_expected.to be_invalid
      }
    end

    context 'title presence and length is less than 50' do
      it {
        task.update(title: 'a' * 50)
        is_expected.to be_valid
      }
    end
  end

  describe '#searching' do
    let!(:task1) { Task.create(title: 'I am title', status: 'todo', user_id: user1.id) }
    let!(:task2) { Task.create(title: 'still doing', status: 'ongoing', user_id: user1.id) }
    let!(:task3) { Task.create(title: 'already done', status: 'done', user_id: user1.id) }
    let!(:task4) { Task.create(title: 'title too but done', status: 'done', user_id: user1.id) }

    context 'only return searched by title' do
      it {
        expect(Task.search_result('I am title', nil, nil)).to eq([task1])
      }
    end

    context 'only return searched by status' do
      it {
        expect(Task.search_result(nil, 'ongoing', nil)).to eq([task2])
      }
    end

    context 'only return searched by title and status' do
      it {
        expect(Task.search_result('title', 'done', nil)).to eq([task4])
      }
    end
  end

  describe '#sorting' do
    let!(:task1) { Task.create(title: 'I am title', due_date: 1.day.from_now, user_id: user1.id) }
    let!(:task2) { Task.create(title: 'still doing', due_date: 3.days.from_now, user_id: user1.id) }
    let!(:task3) { Task.create(title: 'already done', due_date: 2.days.from_now, user_id: user1.id) }

    context 'should order by created at desc' do
      it {
        expect(Task.order_by_due_date_or_default(nil)).to eq([task3, task2, task1])
      }
    end

    context 'should order by due date asc' do
      it {
        expect(Task.order_by_due_date_or_default('ASC')).to eq([task1, task3, task2])
      }
    end

    context 'should order by due date desc' do
      it {
        expect(Task.order_by_due_date_or_default('DESC')).to eq([task2, task3, task1])
      }
    end
  end

  describe '#filtering' do
    let!(:user2) { User.create(name: 'Mary', email: 'user2@example.com', password: 'u2password') }
    let!(:task1) { Task.create(title: 'user1 task', user_id: user1.id) }
    let!(:task2) { Task.create(title: 'user2 task', user_id: user2.id) }

    context 'only return tasks owned by user' do
      it {
        expect(Task.own_by(user1.id)).to eq([task1])
      }
    end
  end

  describe '#labels' do
    let!(:user1) { User.create(name: 'John', email: 'user1@example.com', password: 'u1password') }
    let!(:task1) { Task.create(title: 'user1 task', user_id: user1.id) }
    let!(:label1) { Label.create!(name: 'first label') }

    context 'when task destroyed the task-label assciation also be destroyed' do
      it {
        task1.labels << label1
        Task.find(task1.id).destroy
        expect(TaskLabel.where(task_id: task1.id)).to eq([])
      }
    end
  end

  describe '.search with labels' do
    let!(:user1) { User.create(name: 'John', email: 'user1@example.com', password: 'u1password') }
    let!(:task1) { Task.create(title: 'user1 first task', user_id: user1.id) }
    let!(:task2) { Task.create(title: 'user1 second task', user_id: user1.id) }
    let!(:label1) { Label.create!(name: 'first label') }
    let!(:label2) { Label.create!(name: 'second label') }

    context 'only return searched by labels' do
      it {
        task1.labels << label1
        task2.labels << label2
        expect(Task.search_by_labels(task2.label_ids)).to eq([task2])
      }
    end
  end
end
