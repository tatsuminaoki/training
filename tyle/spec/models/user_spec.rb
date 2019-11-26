# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#create' do

    context 'with the correct parameters' do
      let(:admin_user) { build(:admin_user) }

      it 'successfully creates a task' do
        expect(admin_user).to be_valid
        expect(admin_user.errors.count).to eq(0)
      end
    end

    context 'without a name' do
      let(:admin_user) { build(:admin_user, { name: nil }) }

      it 'shows the error message' do
        expect(admin_user).not_to be_valid
        expect(admin_user.errors[:name]).to include 'を入力してください'
      end
    end

    context 'without a login_id' do
      let(:admin_user) { build(:admin_user, { login_id: nil }) }

      it 'shows the error message' do
        expect(admin_user).not_to be_valid
        expect(admin_user.errors[:login_id]).to include 'を入力してください'
      end
    end

    context 'without a password' do
      let(:admin_user) { build(:admin_user, { password: nil }) }

      it 'shows the error message' do
        expect(admin_user).not_to be_valid
        expect(admin_user.errors[:password]).to include 'を入力してください'
      end
    end

    context 'with 8 digits password' do
      let(:admin_user) { create(:admin_user, { password: 'a' * 8 }) }

      it 'does not show the argument error message' do
        expect(admin_user).to be_valid
        expect(admin_user.errors.count).to eq(0)
      end
    end

    context 'with 7 digits password' do
      let(:admin_user) { build(:admin_user, { password: 'a' * 7 }) }

      it 'shows the argument error message' do
        expect(admin_user).not_to be_valid
        expect(admin_user.errors[:password]).to include 'は8文字以上で入力してください'
      end
    end
  end
end
