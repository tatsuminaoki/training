require 'rails_helper'

RSpec.feature 'AdminUsers', type: :feature do
  describe Admin::UsersController do
    background do
    maintenance = create(:maintenance)
    @admin_user = create(:user, admin: true)
    @general_user = create(:user)
    login(@admin_user)
    end

    feature '画面遷移' do
      scenario 'root_pathからユーザー管理画面に遷移できる' do
        visit root_path
        click_link 'ユーザー管理'
        expect(page).to have_content 'ユーザー一覧'
      end

      scenario 'ユーザー管理画面からユーザー詳細画面に遷移できる' do
        visit admin_users_path
        click_link '詳細', match: :first
        expect(page).to have_content @admin_user.name
      end
    end

    feature '管理者権限の更新、ユーザー削除' do
      scenario '一般ユーザーの管理者権限をありに変更できること' do
        visit admin_user_path(@general_user)
        choose 'あり'
        click_button '管理者権限変更'
        expect(page).to have_checked_field('あり')
      end

      scenario '自分以外の管理者権限をなしに変更できること' do
        visit admin_user_path(@general_user)
        choose 'なし'
        click_button '管理者権限変更'
        expect(page).to have_checked_field('なし')
      end

      scenario '自分以外のユーザーを削除できること' do
        visit admin_user_path(@general_user)
        click_link 'ユーザー削除'
        expect(page).to have_content 'ユーザー情報を削除しました！'
      end

      scenario '管理者が自分だけの時に、管理者権限をなしに変更できないこと' do
        visit admin_user_path(@admin_user)
        choose 'なし'
        click_button '管理者権限変更'
        expect(page).to have_content '管理者がいなくなってしまいます（ ; ; ）'
      end

      scenario '管理者が自分だけの時に、自分のユーザー情報を削除できないこと' do
        visit admin_user_path(@admin_user)
        click_link 'ユーザー削除'
        expect(page).to have_content '管理者がいなくなってしまいます（ ; ; ）'
      end
    end
  end
end
