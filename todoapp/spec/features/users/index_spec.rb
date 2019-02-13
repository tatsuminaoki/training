require 'rails_helper'

feature '管理者機能', type: :feature do
  let!(:user_a) { create(:user, name: 'ユーザーA', role: 2) }
  let!(:user_b) { create(:user, name: 'ユーザーB', email: 'b@a.a', role: 2) }
  let!(:user_c) { create(:user, name: 'ユーザーC', email: 'c@a.a', role: 2) }

  describe 'ユーザー一覧表示機能' do
    context 'ユーザー一覧画面へ遷移した時' do
      background do
        login
        visit admin_users_path
      end

      scenario '作成したユーザーが表示される' do
        expect(page).to have_content 'ユーザーA'
        expect(page).to have_content 'ユーザーB'
        expect(page).to have_content 'ユーザーC'
      end
    end

    context 'ユーザー一覧画面へ遷移した時' do
      background do
        login
        visit admin_users_path
      end

      scenario 'ユーザーの削除ができる' do
        find('/html/body/article/table/tbody/tr[2]/td[8]/form/input[2]').click
        expect(page).to have_content '「ユーザーB」を削除しました。'
      end
    end

    context 'ユーザー一覧画面へ遷移した時' do
      background do
        login
        visit admin_users_path
      end

      scenario 'ログイン中のユーザーは消せない' do
        find('/html/body/article/table/tbody/tr[1]/td[8]/form/input[2]').click
        expect(page).to have_content '自分は消せないよ'
      end
    end
  end
end
