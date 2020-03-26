# frozen_string_literal: true

require 'rails_helper'

describe 'エラーページ表示機能', type: :system do
  let(:user) { FactoryBot.create(:user) }

  before do
    visit login_path
    fill_in 'session_email', with: user.email
    fill_in 'session_password', with: user.password
    click_button 'ログイン'
  end

  it '存在しないタスクにアクセスすると、404ページに遷移する' do
    visit task_path(id: 999_999)
    expect(page).to have_content 'Not Found'
  end

  it '存在しないページにアクセスすると、404ページに遷移する' do
    visit '/power!!!'
    expect(page).to have_content 'Not Found'
  end

  it '422ページに遷移する' do
    allow(Task).to receive(:all).and_raise(ActionController::InvalidAuthenticityToken)
    visit tasks_path
    expect(page).to have_content 'The change you wanted was rejected'
  end

  it '500ページに遷移する' do
    allow(Task).to receive(:all).and_raise(RuntimeError)
    visit tasks_path
    expect(page).to have_content 'Internal Server Error'
  end
end
