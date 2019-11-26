# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#create' do
    let(:user) { create(:admin_user) }

    before do
      user.save
    end

    it 'successfully creates a task' do
      expect(user).to be_valid
      expect(user.errors.count).to eq(0)
    end

    context 'without a name' do
      let(:user) { build(:user, { name: nil }) }

      it 'shows the error message' do
        expect(user.errors[:name]).to include 'を入力してください'
      end
    end

    context 'without a login_id' do
      let(:user) { build(:user, { login_id: nil }) }

      it 'shows the error message' do
        expect(user.errors[:login_id]).to include 'を入力してください'
      end
    end

    context 'without a password' do
      let(:user) { build(:user, { password: nil }) }

      it 'shows the error message' do
        expect(user.errors[:password]).to include 'を入力してください'
      end
    end

    context 'with 8 digits password' do
      let(:user) { create(:user, { password: 'a' * 8 }) }

      it 'does not show the argument error message' do
        expect(user).to be_valid
        expect(user.errors.count).to eq(0)
      end
    end

    context 'with 7 digits password' do
      let(:user) { build(:user, { password: 'a' * 7 }) }

      it 'shows the argument error message' do
        expect(user.errors[:password]).to include 'は8文字以上で入力してください'
      end
    end
  end
end
