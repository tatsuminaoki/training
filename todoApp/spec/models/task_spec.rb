require 'rails_helper'

RSpec.describe Task, :type => :model do
  describe 'Title validation when creates' do
    let(:task) { Task.new(params) }
    let(:params) { { title: title } }
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
    let(:task) { Task.create(title: 'base title') }
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
    let!(:task1) { Task.create(title: 'I am title', status: 'todo') }
    let!(:task2) { Task.create(title: 'still doing', status: 'ongoing') }
    let!(:task3) { Task.create(title: 'already done', status: 'done') }
    let!(:task4) { Task.create(title: 'title too but done', status: 'done') }

    context 'only return searched by title' do
        it {
          expect(Task.search_result('I am title', nil)).to eq([task1])
        }
    end

    context 'only return searched by status' do
      it {
        expect(Task.search_result(nil, 'ongoing')).to eq([task2])
      }
    end

    context 'only return searched by title and status' do
      it {
        expect(Task.search_result('title', 'done')).to eq([task4])
      }
    end
  end
end
