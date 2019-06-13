# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :system do
  specify "Creates a user" do
    visit new_user_path

    fill_in "ユーザー名", with: "hoge"
    fill_in "メールアドレス", with: "test@test.com"
    fill_in "メールアドレス(確認)", with: "test@test.com"

    click_on "登録する"

    expect(page).to have_content("メールを送信しましたので、メール本文のリンク先よりパスワード設定をしてください。")
  end
end
