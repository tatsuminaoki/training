# frozen_string_literal: true

require 'rails_helper'

feature 'ログアウト機能', type: :feature do
  let!(:user) { FactoryBot.create(:user) }

  before do
    login(user)
    page.find('button.navbar-toggler').click
    click_on(user.email)
    click_on('ログアウト')
  end

  context 'ログイン状態からログアウトしたとき' do
    scenario 'メッセージと共にログイン画面が表示される' do
      expect(current_path).to eq login_path
      expect(page).to have_selector('.alert-success', text: 'ログアウトしました')
      expect(page).to have_selector('form', count: 1)
    end
  end
end
