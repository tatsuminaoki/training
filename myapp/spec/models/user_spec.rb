# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#update' do
    let(:user) { create(:user, password: 'password') }

    context 'when empty password' do
      let(:params) { { password: '', account: 'account' } }
      it 'password will be same.' do
        user.update(params)
        expect(user.authenticate('password')).to be_truthy
      end
    end

    context 'when pasword length lt 4' do
      let(:params) { { password: 'a', account: 'account' } }
      it 'can not be updated.' do
        expect(user.update(params)).to be_falsy
      end
    end

    context 'when valid password' do
      let(:params) { { password: 'password2', account: 'account' } }
      it 'can be updated and authenticated with new password' do
        expect(user.update(params)).to be_truthy
        expect(user.authenticate('password2')).to be_truthy
      end
    end
  end

  describe '#save' do
    subject { user.save }

    describe 'password validations' do
      let(:user) { build(:user, password: password) }

      context 'when valid password' do
        let(:password) { 'password' }
        it 'can be saved' do
          is_expected.to be_truthy
        end
      end

      context 'when password is empty' do
        let(:password) { '' }
        it 'can not be saved' do
          is_expected.to be_falsy
        end
      end

      context 'when password length lt 4' do
        let(:password) { 'a' * 3 }
        it 'can be saved' do
          is_expected.to be_falsy
        end
      end
    end

    describe 'account validations' do
      let(:user) { build(:user, account: account) }

      context 'when account conflict' do
        let(:account) { 'user' }

        before do
          create(:user, account: user.account)
        end

        it 'can not be saved' do
          is_expected.to be_falsy
        end
      end

      context 'when account conflict with upcase' do
        let(:account) { 'user' }

        before do
          create(:user, account: user.account.upcase)
        end

        it 'can not be saved' do
          is_expected.to be_falsy
        end
      end

      context 'when account is empty' do
        let(:account) { '' }

        it 'can not be saved' do
          is_expected.to be_falsy
        end
      end

      context 'when account length is lt 4' do
        let(:account) { 'a' * 3 }

        it 'can not be saved' do
          is_expected.to be_falsy
        end
      end
    end
  end

  describe '#tasks' do
    let(:user) { create(:user_with_tasks, tasks_count: 5) }

    describe '#count' do
      subject { user.tasks.count }

      context 'when user deleted' do
        before do
          user.destroy
        end

        it 'should be deleted' do
          is_expected.to eq(0)
        end
      end
    end
  end
end
