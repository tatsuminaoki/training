require 'rails_helper'

RSpec.describe Task, type: :model do
#  before(:each) do
#    @task = build(:task)
#  end
#  it 'title' do
#    expect(@task).to be_valid
#  end

  describe 'title' do
    it 'present: true' do
      @task = build(:task, title: '')
      @task.valid?
      expect(@task.errors[:title]).to include("を入力してください")
    end

    it 'length less than 20' do
      @task = build(:task, title: "a" * 21)
      @task.valid?
      expect(@task.errors[:title]).to include("は20文字以内で入力してください")
    end
  end
end
