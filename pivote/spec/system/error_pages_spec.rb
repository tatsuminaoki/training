# frozen_string_literal: true

require 'rails_helper'

describe 'エラーページ表示機能', type: :system do
  it '404ページに遷移する' do
    # 存在しないページにアクセス
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
