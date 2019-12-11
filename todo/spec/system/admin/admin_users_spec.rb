require 'rails_helper'

RSpec.describe "Admin::Users", type: :system do

  let(:administrator) { create(:administrator) }
  let(:user) { create(:user) }

  describe 'when access index' do
    context 'with logged-in user' do
      let!(:admin_task) { create(:task, user:administrator) }
      it 'success to show admin users page' do
        log_in_as administrator
        visit admin_users_path
        expect(page.current_path).to eq('/admin/users')
        expect(page).to have_content('administrator')
        expect(page).to have_content('1')
      end

      it 'success to click link' do
        log_in_as administrator
        visit admin_users_path
        click_on 'Add New User'
        expect(page.current_path).to eq('/admin/users/new')
      end
    end

    context 'with logged-out user' do
      it 'failed to access' do
        visit admin_users_path
        expect(page.current_path).not_to eq('/admin/users')
      end
    end
  end

  describe 'when access show' do
    let!(:task) { create_list(:task, 26, user: administrator) }

    context 'with logged-in user' do
      it 'success to access' do
        log_in_as administrator
        visit admin_user_path(administrator)
        expect(page.current_path).to eq("/admin/users/#{ administrator.id }")
        expect(page).to have_content('administrator')
        expect(page).to have_content('テストタスク', count: 25)
        expect(page).to have_content('次へ')
      end

      it 'success to click link' do
        log_in_as administrator
        visit admin_user_path administrator
        click_on '編集'
        expect(page.current_path).to eq("/admin/users/#{ administrator.id }/edit")
      end
    end

    context 'with logged-out user' do
      it 'failed to access' do
        visit admin_user_path(administrator)
        expect(page.current_path).not_to eq("/admin/users/#{ administrator.id }")
      end
    end
  end

  describe 'when access new' do
    context 'with logged-in user' do
      it 'success to access' do
        log_in_as administrator
        visit new_admin_user_path
        expect(page.current_path).to eq("/admin/users/new")
      end

      it 'success to add new user' do
        log_in_as administrator
        visit new_admin_user_path
        fill_in 'user_name', with: 'test_user'
        fill_in 'user_password', with: 'test_password'
        fill_in 'user_password_confirmation', with: 'test_password'
        click_on '登録'
        expect(page.current_path).to eq('/admin/users')
        expect(page).to have_content 'Success!'
      end
    end

    context 'with logged-out user' do
      it 'failed to access' do
        visit new_admin_user_path
        expect(page.current_path).not_to eq('/admin/users/new')
      end
    end
  end

  describe 'when access edit' do
    context 'with logged-in user' do
      it 'success to access' do
        log_in_as administrator
        visit edit_admin_user_path user
        expect(page.current_path).to eq("/admin/users/#{ user.id }/edit")
      end

      it 'success to edit user' do
        log_in_as administrator
        visit edit_admin_user_path user
        expect(page.current_path).to eq("/admin/users/#{ user.id }/edit")
        fill_in 'user_name', with: 'test_user1'
        fill_in 'user_password', with: 'test_password1'
        fill_in 'user_password_confirmation', with: 'test_password1'
        click_on '更新'
        expect(page.current_path).to eq('/admin/users')
        expect(page).to have_content 'Success!'
      end
    end

    context 'with logged-out user' do
      it 'failed to access' do
        visit edit_admin_user_path user
        expect(page.current_path).not_to eq("/admin/users/#{ user.id }/edit")
      end
    end
  end

  describe 'when delete user' do
    context 'with logged-in user' do
      it 'success' do
        log_in_as administrator
        visit admin_user_path user
        click_on '削除'
        expect(page.current_path).to eq('/admin/users')
        expect(page).to have_content 'Deleted'
        expect(page).not_to have_content 'test_user'
      end
    end
  end
end
