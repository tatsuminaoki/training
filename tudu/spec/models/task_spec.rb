require 'rails_helper'

RSpec.describe Task, type: :model do
  context 'validate task' do
    scenario 'is valid with task' do
      task = build(:task)
      expect(task).to be_valid
    end

    scenario 'is invalid with task' do
      params = [
        # name なし, content あり
        {
          name: nil,
          content: 'content',
        },
        # name あり, content なし
        {
          name: 'name',
          content: nil,
        },
        # name あり (文字数オーバー) , content あり
        {
          name: 'a' * 21,
          content: 'content',
        },
        # name あり, content あり (文字数オーバー)
        {
          name: 'name',
          content: 'c' * 501
        },
        {
          name: 'name',
          content: 'content',
          status: 4
        },
        {
          name: 'name',
          content: 'content',
          exipire_date: 'invalid-date'
        }
      ]

      params.each do |param|
        task = build(
          :task,
          name: param[:name],
          content: param[:content],
          status: param[:status],
          expire_date: param[:expire_date]
        )
        expect(task).not_to be_valid
      end
    end
  end
end
