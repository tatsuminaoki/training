require 'rails_helper'

RSpec.describe Task, :type => :model do
  context 'When user searching' do
    before do
      Task.create!(title: 'title keyword', status: 'todo')
      Task.create!(title: 'i am not', status: 'ongoing')
    end

    it 'should return only searched title when searched by title' do
      expect(Task.search_by_title('title keyword').pluck(:title)).to eq(['title keyword'])
    end

    it 'should return only searched status when searched by status' do

    end
  end

end
