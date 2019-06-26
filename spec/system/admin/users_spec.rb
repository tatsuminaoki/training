# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::Users', type: :system do
  let(:user) { create(:user) }

  specify 'Administrator user operates from creation to editing to deletion' do
    user_login(user: user)

    click_on 'ユーザー管理'

    expect(page).to have_content('ユーザー管理')

    click_on '新規'

    fill_in 'ユーザー名', with: 'hogehoge'
    fill_in 'メールアドレス', with: 'fugafuga@test.com'
    fill_in 'メールアドレス(確認)', with: 'fugafuga@test.com'
    fill_in 'パスワード', with: 'hogehoge'
    fill_in 'パスワード(確認)', with: 'hogehoge'

    click_on '登録する'

    expect(page).to have_content('ユーザーの登録が完了しました。')

    expect(page).to have_content('hogehoge')
    expect(page).to have_content('fugafuga@test.com')

    first(:link, '編集').click

    expect(page).to have_content('ユーザー編集')

    fill_in 'ユーザー名', with: 'hoge-update'
    fill_in 'メールアドレス(確認)', with: 'fugafuga@test.com'

    click_on '更新する'

    expect(page).to have_content('ユーザーの更新が完了しました。')
    expect(page).to have_content('hoge-update')
    expect(page).to have_content('fugafuga@test.com')

    expect(page).to have_content('ユーザー管理')

    first(:link, '削除').click

    # TODO: headless chrome が無効だと効かないのでコメントアウトします
    # expect(page.driver.browser.switch_to.alert.text).to eq '本当によろしいですか？'

    # page.driver.browser.switch_to.alert.accept

    expect(page).to have_content('ユーザーの削除が完了しました。')
  end

  context '一般ユーザーがユーザー管理機能を操作するしようとすると' do
    before do
      create(:user,
             email: 'test2@example.com',
             email_confirmation: 'test2@example.com',
            )
      user.role_general!
    end

    specify 'redirects to root_path page' do
      user_login(user: user)

      expect(page).not_to have_content('ユーザー管理')

      visit admin_users_path

      expect(page).not_to have_content('ユーザー管理')

      visit new_admin_user_path

      expect(page).not_to have_content('ユーザー管理')
      expect(page).not_to have_content('ユーザー登録')
    end
  end

  context '一人のみ管理者ユーザーが自身の権限を一般に変更しようとすると' do
    before do
      create(:user,
             email: 'test3@example.com',
             email_confirmation: 'test3@example.com',
             role: :general,
            )
    end

    specify '権限を変更できないこと' do
      user_login(user: user)

      click_on 'ユーザー管理'

      expect(page).to have_content('ユーザー管理')

      # TODO: headless chromeを有効にしないと下記コメントアウトでの指定ができない(?)ので直接遷移するように記述しています
      # tds = all('td')
      # tds[14].click
      visit edit_admin_user_path(user)

      expect(page).to have_content('ユーザー編集')

      select '一般', from: '権限'
      fill_in 'メールアドレス(確認)', with: 'test@test.com'

      click_on '更新する'

      expect(page).to have_content('権限は、変更できません。変更する場合は、別の管理者ユーザーを用意してください。')
    end
  end
end
