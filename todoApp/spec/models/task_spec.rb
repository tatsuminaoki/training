require 'rails_helper'

RSpec.describe Task, :type => :model do
  describe '#searching' do
    let!(:task1) { Task.create(title: 'title keyword', status: 0) }
    let!(:task2) { Task.create(title: 'still doing', status: 1) }

    context 'only return searched title' do
        it {
          puts Task.search_by_title('title keyword').inspect
          expect(Task.search_by_title('title keyword').pluck(:title)).to eq(task1.title)
        }
    end

    context 'only return searched status' do
      it {
        puts task2.status
        puts Task.search_by_status(task2.status).inspect
        # puts Task.where('status = ?', task2.status).inspect
        expect(Task.search_by_status(task2.status).pluck(:title)).to eq(task2.title)
      }
    end

  end

  # context 'When user searching' do
  #   before do
  #     task1 = Task.create!(title: 'title keyword', status: 'todo')
  #     task2 = Task.create!()
  #   end
  #
  #   it 'should return only searched title when searched by title' do
  #     expect(Task.search_by_title('title keyword').title).to eq(task1.title)
  #   end
  #
  #   it 'should return only searched status when searched by status' do
  #     expect(Task.search_by_status(task2.status).title).to eq(task2.title)
  #   end
  # end

end
