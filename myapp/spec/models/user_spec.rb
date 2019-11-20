# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
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

      context 'when invalid password' do
        let(:password) { '' }
        it 'can not be saved' do
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

      context 'when account is empty' do
        let(:account) { '' }

        it 'can not be saved' do
          is_expected.to be_falsy
        end
      end
    end
  end

  describe "#tasks" do
    let(:user) { create(:user_with_tasks, tasks_count: 5) }
    let(:count) { Task.where(user_id: user.id).count }
    subject { count }

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
