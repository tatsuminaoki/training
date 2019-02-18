require 'rails_helper'

describe Label, type: :model do
  let(:user_a) { build(:user) }

  describe 'nameのバリデーションチェック' do
    context '何も入力されてない時' do
      example 'エラーになる' do
        label = build(:label, user_id: user_a.id, name: '')
        expect(label).to be_invalid
      end
    end
    context '1文字入力されてる時' do
      example '登録可能' do
        label = build(:label, user_id: user_a.id, name: '1')
        expect(label).to be_valid
      end
    end
    context '12文字入力されてる時' do
      example '登録可能' do
        label = build(:label, user_id: user_a.id, name: 'a' * 12)
        expect(label).to be_valid
      end
    end
    context '13文字入力されてる時' do
      example 'エラーになる' do
        label = build(:label, user_id: user_a.id, name: 'a' * 13)
        expect(label).to be_invalid
      end
    end
  end
end
