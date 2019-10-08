require 'rails_helper'
require 'i18n'
require 'faker'

RSpec.feature "Authentication", type: :feature, js: true do
  let(:email) { Faker::Internet.email }
  let(:password) { Faker::Internet.password(min_length: 8) }
  given!(:user) { create(:user, email: email, password: password) }

  ### 会員登録

  scenario '会員登録する' do
    visit root_path
    click_link I18n.t('button.signup')

    email = Faker::Internet.email
    password = Faker::Internet.password

    fill_in 'user_email', with: email
    fill_in 'user_password', with: password
    fill_in 'user_password_confirmation', with: password
    find('input[type=submit]').click

    expect(page).to have_text I18n.t('message.success.complete_create')
  end

  scenario 'メアドを入力せず会員登録する' do
    visit root_path
    click_link I18n.t('button.signup')

    fill_in 'user_password', with: password
    fill_in 'user_password_confirmation', with: password
    find('input[type=submit]').click
    # 無効なメアドが入力されたためフォーム送信せず#user_email要素にアラートを出す
    expect(page).to have_text I18n.t('activerecord.users.new.title')
  end

  scenario '無効なメアドで会員登録する' do
    visit root_path
    click_link I18n.t('button.signup')

    fill_in 'user_email', with: Faker::Game.title
    fill_in 'user_password', with: password
    fill_in 'user_password_confirmation', with: password
    find('input[type=submit]').click
    # 無効なメアドが入力されたためフォーム送信せず#user_email要素にアラートを出す
    expect(page).to have_text I18n.t('activerecord.users.new.title')
  end

  scenario 'すでに存在するメアドで会員登録する' do
    old_user = create(:user)

    visit root_path
    click_link I18n.t('button.signup')

    fill_in 'user_email', with: old_user.email
    fill_in 'user_password', with: password
    fill_in 'user_password_confirmation', with: password
    find('input[type=submit]').click

    expect(page).to have_text I18n.t('message.error.occurred')
  end

  scenario 'パスワードを入力せず会員登録する' do
    visit root_path
    click_link I18n.t('button.signup')

    fill_in 'user_email', with: email
    fill_in 'user_password', with: ''
    fill_in 'user_password_confirmation', with: ''
    find('input[type=submit]').click

    # フォーム送信せず#user_password要素にアラートを出す
    expect(page).to have_text I18n.t('activerecord.users.new.title')
  end

  scenario '一致しないパスワードを入力して会員登録する' do
    visit root_path
    click_link I18n.t('button.signup')

    fill_in 'user_email', with: email
    fill_in 'user_password', with: password
    fill_in 'user_password_confirmation', with: Faker::Internet.password(min_length: 8)
    find('input[type=submit]').click

    expect(page).to have_text I18n.t('message.error.occurred')
  end

  ### ログイン

  scenario 'ログインする' do

    visit root_path
    click_link I18n.t('button.login')

    fill_in 'email', with: email
    fill_in 'password', with: password
    find('input[type=submit]').click

    expect(page).to have_text I18n.t('message.success.complete_login')
  end

  scenario '存在しないメアドでログインする' do
    visit root_path
    click_link I18n.t('button.login')

    fill_in 'email', with: Faker::Internet.email
    fill_in 'password', with: password
    find('input[type=submit]').click

    expect(page).to have_text I18n.t('message.error.login')
  end

  scenario '間違ったパスワードでログインする' do
    visit root_path
    click_link I18n.t('button.login')

    fill_in 'email', with: email
    fill_in 'password', with: Faker::Internet.password(min_length: 8)
    find('input[type=submit]').click

    expect(page).to have_text I18n.t('message.error.login')
  end

  scenario '間違ったパスワードでログインする' do
    visit root_path
    click_link I18n.t('button.login')

    fill_in 'email', with: email
    fill_in 'password', with: Faker::Internet.password(min_length: 8)
    find('input[type=submit]').click

    expect(page).to have_text I18n.t('message.error.login')
  end

  ### ログアウト

  scenario 'ログアウトする' do
    visit root_path
    click_link I18n.t('button.login')

    # まずはログインする
    fill_in 'email', with: email
    fill_in 'password', with: password
    find('input[type=submit]').click

    expect(page).to have_text I18n.t('message.success.complete_login')

    # その後ログアウトする
    click_link I18n.t('button.logout')
    expect(page).to have_text I18n.t('message.success.complete_logout')
  end
end
