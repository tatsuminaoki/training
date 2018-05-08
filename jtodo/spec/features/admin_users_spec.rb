require 'rails_helper'

RSpec.feature "Users", type: :feature do
  let!(:admin) { create :user, name: 'admin_user', is_admin: true }
  let!(:users) { create_list :user_with_tasks, 3 }

  scenario 'ログインして管理メニューに接続できる' do
    visit login_path

    fill_in 'session_name', with: 'admin_user'
    fill_in 'session_password', with: 'userpass'

    submit_form

    click_on I18n.t('layouts.header.admin')

    expect(page).to have_content I18n.t('admin.users.index.title')
  end

  scenario '管理メニューでユーザー登録して削除する' do
    visit login_path

    fill_in 'session_name', with: 'admin_user'
    fill_in 'session_password', with: 'userpass'

    submit_form

    click_on I18n.t('layouts.header.admin')
    click_on I18n.t('admin.users.index.new_user')

    fill_in 'user_name', with: 'created_by_admin'
    fill_in 'user_password', with: 'testpass'
    fill_in 'user_password_confirmation', with: 'testpass'

    submit_form

    expect(all('td').last).to have_content I18n.t('admin.users.index.delete')

    within all('td').last do
      click_on I18n.t('admin.users.index.delete')
    end

    expect(page).to_not have_content 'created_by_admin'

  end

  scenario '一般ユーザーが管理メニューに入れない' do
    visit login_path

    fill_in 'session_name', with: users[0].name
    fill_in 'session_password', with: 'userpass'

    submit_form

    visit admin_root_path

    expect(current_path).to_not eql(admin_root_path)
  end

  scenario '一般ユーザーを削除するときにタスクも一緒に削除される' do
    visit login_path

    fill_in 'session_name', with: 'admin_user'
    fill_in 'session_password', with: 'userpass'

    submit_form

    click_on I18n.t('layouts.header.admin')

    expect(all('td').last).to have_content I18n.t('admin.users.index.delete')

    within all('td').last do
      click_on I18n.t('admin.users.index.delete')
    end

    expect(page).to_not have_content users[2].name
    expect(users[2].tasks).to be_empty

  end

end
