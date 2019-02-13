require 'rails_helper'

feature '管理者機能', type: :feature do
  let!(:user_a) { create(:user, name: 'ユーザーA', role: User::ROLE_ADMIN) }
  let!(:user_b) { create(:user, name: 'ユーザーB', email: 'b@a.a', role: User::ROLE_ADMIN) }

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
        expect(page).to have_field '役割', disabled: true
        find("option[value='general']").select_option
        expect(page).to have_field '役割', disabled: true

        js = "document.querySelector('#user_role').disabled = false;"
        page.execute_script js
        expect(page).to have_field '役割', disabled: false

        find("option[value='general']").select_option
        expect(page).to have_select('user[role]', selected: '一般')

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
