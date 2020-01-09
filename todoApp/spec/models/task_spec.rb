require 'rails_helper'

RSpec.describe Task, :type => :model do
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
