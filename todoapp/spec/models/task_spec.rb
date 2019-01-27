require 'rails_helper'

describe Task, type: :model do
  let(:user_a) { build(:user, name: 'ユーザーA') }

  describe 'titleのバリデーションチェック' do
    context '何も入力されてないとき' do
      example 'エラーになる' do
        task = build(:task, user: user_a, title: '')
        expect(task).to be_invalid
      end
    end
    context '1文字入力されてる時' do
      example '登録可能' do
        task = build(:task, user: user_a, title: '1')
        expect(task).to be_valid
      end
    end
    context '64文字入力されてる時' do
      example '登録可能' do
        task = build(:task, user: user_a, title: 'a' * 64)
        expect(task).to be_valid
      end
    end
    context '65文字入力されてる時' do
      example 'エラーになる' do
        task = build(:task, user: user_a, title: 'a' * 65)
        expect(task).to be_invalid
      end
    end
  end

  describe 'end_atのバリデーションチェック' do
    context '過去日付が入力された時1' do
      example 'エラーになる' do
        task = build(:task, user: user_a, end_at: '2019-01-01 23:59:59')
        expect(task).to be_invalid
      end
    end
    context '過去日付が入力された時2' do
      example 'エラーになる' do
        task = build(:task, user: user_a, end_at: Time.now.to_date - 1)
        expect(task).to be_invalid
      end
    end
    context '現在日付が入力された時' do
      example '登録可能' do
        task = build(:task, user: user_a, end_at: Time.now.to_date)
        expect(task).to be_valid
      end
    end
    context '未来日付が入力された時' do
      example '登録可能' do
        task = build(:task, user: user_a, end_at: '2100-01-01 23:59:59')
        expect(task).to be_valid
      end
    end
  end
end
