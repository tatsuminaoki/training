# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserCredential, type: :model do
  describe '#save' do
    let(:user) { create(:user) }
    let(:user_credential) { user.build_user_credential(password: 'a' * 6) }

    before do
      user_credential.save
    end

    it 'creates records in user_credential' do
      expect(UserCredential.count).to eq(1)
      expect(user_credential.errors.count).to eq(0)
    end

    context 'passwordへ5文字の入力があると' do
      let(:user_credential) { user.build_user_credential(password: 'a' * 5) }

      it '桁数不足のエラーメッセージが出ること' do
        expect(UserCredential.count).to eq(0)
        expect(user_credential.errors[:password]).to include('は6文字以上で入力してください')
      end
    end
  end
end
