require 'rails_helper'

RSpec.feature 'AdminUsers', type: :feature do
  describe Admin::UsersController do
    background do
    @user = create(:user)
    login(@user)
    @task = create(:task, user_id: @user.id)
    end

    feature '画面遷移' do
      scenario 'root_pathからユーザー管理画面に遷移できる' do
        visit root_path
        click_link 'ユーザー管理'
        expect(page).to have_content 'ユーザー一覧'
      end

      scenario 'ユーザー管理画面からユーザー詳細画面に遷移できる' do
        visit admin_users_path
        click_link '詳細'
        expect(page).to have_content @user.name
      end
    end
  end
end