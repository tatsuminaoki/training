# frozen_string_literal: true

require 'rails_helper'

describe 'ユーザー一覧画面', type: :feature do
  describe 'アクセス' do
    let!(:user) { create(:user) }

    context '非ログイン状態でアクセスした場合' do
      it 'ログイン画面が表示されること' do
        visit admin_users_path
        expect(page).to have_css('.form-signin')
      end
    end

    context 'ログイン状態でアクセスした場合' do
      it 'ユーザー一覧画面が表示されること' do
        visit_after_login(user: user, visit_path: admin_users_path)
        expect(page).to have_css('#users_list')
      end
    end
  end
end
