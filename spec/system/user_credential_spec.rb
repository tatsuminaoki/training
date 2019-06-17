# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'UserCredentials', type: :system do
  let(:user_token) { create(:user_token) }

  specify 'An user sets own password' do
    visit new_user_credential_path(id: user_token.token)

    fill_in 'user_credential[password]', with: 'hoge'
    fill_in 'user_credential[password_confirmation]', with: 'fuga'

    click_on '登録する'

    expect(page).to have_content('入力が一致しません')

    fill_in 'user_credential[password]', with: 'hogefuga'
    fill_in 'user_credential[password_confirmation]', with: 'hogefuga'

    click_on '登録する'

    expect(page).to have_content('パスワード設定が完了しましたので、こちらからログインしてください。')
  end
end
