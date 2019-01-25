require 'rails_helper'

describe Task, type: :model do
  let(:user_a) { create(:user, name: 'ユーザーA') }

  describe 'titleのバリデーションチェック' do
    context '何も入力されてないとき' do
      example 'エラーになる' do
        expect{
          create(:task, user: user_a, title: '')
        }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
    context '1文字入力されてる時' do
      example '登録可能' do
        task = create(:task, user: user_a, title: '1')
        expect(task).to be_valid
      end
    end
    context '64文字入力されてる時' do
      example '登録可能' do
        task = create(
            :task,
            user: user_a,
            title: '1234567890123456789012345678901234567890123456789012345678901234')
        expect(task).to be_valid
      end
    end
    context '65文字入力されてる時' do
      example 'エラーになる' do
        expect{
          create(
              :task,
              user: user_a,
              title: '12345678901234567890123456789012345678901234567890123456789012345')
        }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end

  describe 'end_atのバリデーションチェック' do
    context '過去日付が入力された時' do
      example 'エラーになる' do
        expect{
          create(:task, user: user_a, end_at: '2019-01-01 23:59:59')
        }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
    context '未来日付が入力された時' do
      example '登録可能' do
        task = create(:task, user: user_a, end_at: '2100-01-01 23:59:59')
        expect(task).to be_valid
      end
    end
  end
end
