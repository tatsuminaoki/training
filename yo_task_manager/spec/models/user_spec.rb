# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'many admins' do
    let!(:admin_users) { create_list(:user, 3, role: 'admin') }
    let!(:user) { create(:user, role: role) }
    context 'change role from admin to common' do
      let(:role) { 'admin' }
      it 'role should be updated' do
        expect(user.common!).to be true
        expect(user.role).to eq 'common'
      end
    end
    context 'change role from common to admin' do
      let(:role) { 'common' }
      it 'role should be updated' do
        expect(user.admin!).to be true
        expect(user.role).to eq 'admin'
      end
    end
  end

  describe 'final admin' do
    let!(:common_users) { create_list(:user, 3, role: 'common') }
    let!(:user) { create(:user, role: role) }
    context 'change role from admin to common' do
      let(:role) { 'admin' }
      it 'role cannot be changed and have errors msg' do
        expect { user.common! }.to raise_error(ActiveRecord::RecordInvalid)
        expect(user.errors[:role]).to eq [' 最後のアドミンなので、変更・削除はできません！']
        expect(user.reload.role).to eq 'admin'
      end
    end

    context 'destroy final admin' do
      let(:role) { 'admin' }
      it 'cannot destroy record and have errors msg' do
        expect(user.destroy).to be_falsey
        expect(user.errors[:role]).to eq [' 最後のアドミンなので、変更・削除はできません！']
      end
    end
  end
end
