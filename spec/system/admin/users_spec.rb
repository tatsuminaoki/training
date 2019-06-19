# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::Users', type: :system do
  let(:user) { create(:user) }

  specify 'User operates from creation to editing to deletion' do
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
end
