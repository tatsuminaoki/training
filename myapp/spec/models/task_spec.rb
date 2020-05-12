require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'title column' do
    context 'when title is null' do
      let(:task) { build(:task, title: '') }
      it 'raise not null validation massage' do
        task.valid?
        expect(task.errors[:title]).to include("を入力してください")
      end
    end

    context 'when title is 21 or more' do
      let(:task) { build(:task, title: "a" * 21) }
      it 'raise length validation message' do
        task.valid?
        expect(task.errors[:title]).to include("は20文字以内で入力してください")
      end
    end
  end
end
