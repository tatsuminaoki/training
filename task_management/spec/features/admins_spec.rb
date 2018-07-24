require 'rails_helper'

RSpec.feature "Admins", type: :feature do
  background do
    @user = create(:user)
  end

  feature '画面遷移' do
    background do
      login(@user.mail_address, @user.password)
    end
    context '管理ユーザが管理画面にアクセスする' do
      given!(:task) {create(:task, user_id: @user.id)}
      scenario '管理画面を表示する' do
        visit admin_users_path
        expect(page).to have_content @user.user_name
        expect(page).to have_content I18n.t('button.new')
        expect(page).to have_content I18n.t('view.user.user_name', :user => @user.user_name)
        expect(page).to have_content I18n.t('view.task_quantity', :quantity => 1)
      end
    end

    context '一般ユーザが管理画面にアクセスする' do
      given(:general_user){create(:user, admin: 'general')}
      scenario 'タスク一覧画面に遷移してエラーメッセージが表示される' do
        logout
        login(general_user.mail_address, general_user.password)
        visit admin_users_path

        expect(current_path).to eq root_path
        expect(page).to have_content '管理者以外はアクセスできません'
      end
    end

    context '管理画面で「新規作成」をクリックする' do
      scenario 'ユーザ作成画面に遷移する' do
        visit admin_users_path
        click_on I18n.t('button.new')

        expect(current_path).to eq new_admin_user_path
        expect(page).to have_field 'user_user_name'
        expect(page).to have_field 'user_mail_address'
        expect(page).to have_field 'user_password'
        expect(page).to have_button I18n.t('helpers.submit.create')
      end
    end

    context '管理画面でユーザ名をクリックする' do
      given!(:task) {create(:task, user_id: @user.id)}
      scenario 'ユーザ詳細画面に遷移する' do
        visit admin_users_path
        click_on I18n.t('view.user.user_name', :user => @user.user_name)

        expect(current_path).to eq admin_user_path(id: @user.id)
        expect(page).to have_content 'ユーザ情報'
        expect(page).to have_content I18n.t('view.user.user_name', user: @user.user_name)
        expect(page).to have_content I18n.t('view.user.mail_address', user: @user.mail_address)
        expect(page).to have_content I18n.t('view.user.role', user: I18n.t("role.#{@user.admin}"))
        expect(page).to have_content I18n.t('button.edit')
        expect(page).to have_content I18n.t('button.delete')
        expect(page).to have_content 'タスク'
        expect(page).to have_content task.task_name
      end
    end

    context 'ユーザ詳細画面で「編集」をクリックする' do
      scenario 'ユーザ編集画面に遷移する' do
        visit admin_user_path(id: @user.id)
        click_on I18n.t('button.edit')

        expect(current_path).to eq edit_admin_user_path(id: @user.id)
        expect(page).to have_field 'user_user_name', with: @user.user_name
        expect(page).to have_field 'user_mail_address', with: @user.mail_address
        expect(page).to have_field 'user_password'
        expect(page).to have_button I18n.t('helpers.submit.update')
      end
    end
  end

  feature 'ユーザの登録' do
    background do
      login(@user.mail_address, @user.password)
    end

    context '正常な値を入力した場合' do
      scenario '登録に成功する' do
        visit new_admin_user_path	
        fill_in 'user_user_name', with: 'new_account'
        fill_in 'user_mail_address', with: 'new@example.com'
        fill_in 'user_password', with: 'new_password'
        select I18n.t('role.admin'), from: 'user_admin'
        click_button I18n.t('helpers.submit.create')

        expect(current_path).to eq admin_users_path
        expect(page).to have_content 'ユーザの作成に成功しました'
        expect(page).to have_content I18n.t('view.user.user_name', :user => 'new_account')
        expect(page).to have_content I18n.t('view.task_quantity', :quantity => 0)
      end
    end

    context '何も入力しない場合' do
      scenario '登録に失敗してエラーメッセージが表示される' do
        visit new_admin_user_path
        fill_in 'user_user_name', with: ''
        fill_in 'user_mail_address', with: ''
        fill_in 'user_password', with: ''
        click_button I18n.t('helpers.submit.create')

        expect(current_path).to eq admin_users_path
        expect(page).to have_content 'ユーザの作成に失敗しました'
        expect(page).to have_content 'ユーザ名を入力してください'
        expect(page).to have_content 'パスワードを入力してください'
        expect(page).to have_content 'メールアドレスを入力してください'
      end
    end
  end

  feature 'ユーザの更新' do
    given(:logined_user) {create(:user, user_name: 'logined_user')}
    background do
      login(logined_user.mail_address, logined_user.password)
    end

    context '全てのフォームに正常な値を入力した場合' do
      scenario '入力した値に更新される' do
        visit edit_admin_user_path(id: @user.id)
        fill_in 'user_user_name', with: 'changed_name'
        fill_in 'user_mail_address', with: 'changed@example.com'
        fill_in 'user_password', with: 'changed_password'
        select I18n.t('role.general'), from: 'user_admin'
        click_button I18n.t('helpers.submit.update')

        expect(current_path).to eq admin_user_path(id: @user.id)
        expect(page).to have_content 'アカウント情報を更新しました'
        expect(page).to have_content 'ユーザ名：changed_name'
        expect(page).to have_content 'メールアドレス：changed@example.com'
        expect(page).to have_content 'ロール：一般ユーザ'
      end
    end

    context 'メールアドレス以外を更新する場合' do
      scenario 'メールアドレス以外が正常に更新される' do
        visit edit_admin_user_path(id: @user.id)
        fill_in 'user_user_name', with: 'changed_name'
        fill_in 'user_password', with: 'changed_password'
        click_button I18n.t('helpers.submit.update')

        expect(current_path).to eq admin_user_path(id: @user.id)
        expect(page).to have_content 'アカウント情報を更新しました'
        expect(page).to have_content 'ユーザ名：changed_name'
        expect(page).to have_content "メールアドレス：#{@user.mail_address}"
      end
    end

    context 'パスワードフォームだけ未入力の場合' do
      scenario 'パスワード以外入力した値に更新される' do
        visit edit_admin_user_path(id: @user.id)
        fill_in 'user_user_name', with: 'changed_name'
        fill_in 'user_mail_address', with: 'changed@example.com'
        click_button I18n.t('helpers.submit.update')

        expect(current_path).to eq admin_user_path(id: @user.id)
        expect(page).to have_content 'アカウント情報を更新しました'
        expect(page).to have_content 'ユーザ名：changed_name'
        expect(page).to have_content 'メールアドレス：changed@example.com'
      end
    end

    context '何も入力しない場合' do
      scenario '更新に失敗する' do
        visit edit_admin_user_path(id: @user.id)
        fill_in 'user_user_name', with: ''
        fill_in 'user_mail_address', with: ''
        click_button I18n.t('helpers.submit.update')

        expect(current_path).to eq admin_user_path(id: @user.id)
        expect(page).to have_content 'アカウント情報の更新に失敗しました'
        expect(page).to have_content 'ユーザ名を入力してください'
        expect(page).to have_content 'メールアドレスを入力してください'
      end
    end

    context 'ログイン中のユーザのロールを変更する場合' do
      scenario '変更に失敗してエラーメッセージが表示される' do
        visit edit_admin_user_path(id: logined_user.id)
        select I18n.t('role.general'), from: 'user_admin'
        click_button I18n.t('helpers.submit.update')

        expect(current_path).to eq edit_admin_user_path(id: logined_user.id)
        expect(page).to have_content 'ログイン中のユーザはロールを変更できません'
      end
    end
  end

  feature 'ユーザの削除', js: true do
    given(:logined_user) {create(:user, user_name: 'logined_user')}
    background do
      login(logined_user.mail_address, logined_user.password)
      expect(page).to have_content logined_user.user_name
    end

    context 'ログインしていないユーザを削除する場合' do
      scenario '削除に成功する' do
        visit admin_user_path(id: @user.id)
        page.accept_confirm{click_on I18n.t('button.delete')}

        expect(current_path).to eq admin_users_path
        expect(page).to have_content "ユーザ：#{@user.user_name}を削除しました"
        expect(page).not_to have_content I18n.t('view.user_name', :user => @user.user_name)
      end
    end
    
    context '確認ダイアログでキャンセルした場合' do
      scenario '削除せずにユーザ詳細画面に戻る' do
        visit admin_user_path(id: @user.id)
        page.dismiss_confirm{click_on I18n.t('button.delete')}
        
        expect(current_path).to eq admin_user_path(id: @user.id)
        expect(page).not_to have_content "ユーザ：#{@user.user_name}を削除しました"
      end
    end

    context 'ログイン中のユーザを削除する場合' do
      scenario '削除に失敗してエラーメッセージが表示される' do
        visit admin_user_path(id: logined_user.id)
        page.accept_confirm{click_on I18n.t('button.delete')}

        expect(current_path).to eq admin_user_path(id: logined_user.id)
        expect(page).to have_content 'ログイン中のユーザは削除できません'
      end
    end
  end

  feature 'ロール' do
    given(:admin_user){create(:user)}
    given(:general_user){create(:user, admin: 'general')}

    context '管理ユーザがログインした場合' do
      scenario 'ナビゲーションバーに管理画面へのリンクが表示される' do
        login(admin_user.mail_address, admin_user.password)

        expect(page).to have_content I18n.t('view.nav.admin')
      end
    end

    context '一般ユーザがログインした場合' do
      scenario 'ナビゲーションバーに管理画面へのリンクが表示されない' do
        login(general_user.mail_address, general_user.password)

        expect(page).not_to have_content I18n.t('view.nav.admin')
      end
    end
  end
end
