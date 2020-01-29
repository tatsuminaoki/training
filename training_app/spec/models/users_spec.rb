# frozen_string_literal: true

require 'rails_helper'

describe User do
  describe '削除時チェック' do
    context '管理ユーザーが2名以上存在' do
      let!(:user1) { create(:user, role: :admin) }
      let!(:user2) { create(:user, role: :admin) }

      it '削除することができる' do
        user1.destroy!
        expect(User.count).to eq(1)
      end
    end

    context '管理ユーザーが1人しかいない場合' do
      let!(:user1) { create(:user, role: :admin) }
      let!(:user2) { create(:user, role: :normal) }

      it '削除できません' do
        expect {
          user1.destroy!
        }.to raise_error(ActiveRecord::RecordNotDestroyed)
      end
    end
  end

  describe '更新時チェック' do
    context '管理ユーザーが2名以上存在' do
      let!(:user1) { create(:user, role: :admin) }
      let!(:user2) { create(:user, role: :admin) }

      it '管理ユーザーから一般ユーザーになることができる' do
        user1.role = :normal
        user1.save
        expect(User.where(role: :admin).count).to eq(1)
      end
    end

    context '管理ユーザーが1名以上いない場合　' do
      let!(:user1) { create(:user, role: :admin) }
      let!(:user2) { create(:user, role: :normal) }

      it '管理ユーザーから一般ユーザーになることはできない' do
        user1.role = :admin
        user1.save

        expect(User.where(role: :admin).count).to eq(1)
      end
    end
  end
end
