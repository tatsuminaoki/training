require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'name varidates' do
    context 'with nil' do
      it 'could not save' do
        task = Task.new(name: nil)
        expect(task.save).to be_falsey
      end
    end
    context 'with not nil' do
      it 'could save' do
        task = Task.new(name: 'name')
        expect(task.save).to be_truthy
      end
    end
  end
end
