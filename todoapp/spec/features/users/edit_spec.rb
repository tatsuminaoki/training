require 'rails_helper'

feature '管理者機能', type: :feature do
  let!(:user_a) { create(:user, name: 'ユーザーA', role: 2) }
  let!(:user_b) { create(:user, name: 'ユーザーB', email: 'b@a.a', role: 2) }

  describe '更新機能' do
    context '更新画面へ遷移した時' do
      background do
        login
        visit edit_admin_user_path(user_a)
      end

      scenario '入力フォームがある' do
        expect(page).to have_content '入力フォーム'
      end
    end

    context '更新画面へ遷移した時', js: true do
      background do
        login
        visit edit_admin_user_path(user_a)
      end

      scenario 'ログインしているユーザの役割は変更できない' do
        js = "document.querySelector('#user_role').disabled = false;"
        page.execute_script js

        find("option[value='general']").select_option
        click_button '更新する'
        expect(page).to have_content '自分の役割は変えれないよ'
      end
    end

    context '更新画面へ遷移した時' do
      background do
        login
        visit edit_admin_user_path(user_b)
      end

      scenario 'ログインしてないユーザの役割は変更できる' do
        find("option[value='general']").select_option
        click_button '更新する'
        expect(page).to have_content '「ユーザーB」を更新しました。'
      end
    end
  end
end
