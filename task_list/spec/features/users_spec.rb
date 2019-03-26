require 'rails_helper'

RSpec.feature 'Users', type: :feature do
  feature '新規ユーザー登録のバリデーション' do
    scenario 'name,email,passwordがあれば新規ユーザー登録ができる' do
      expect(create(:user)).to be_valid
    end

    scenario 'nameが空では新規ユーザー登録できない' do
      expect(build(:user, name: '')).to_not be_valid
    end

    scenario 'nameが30文字だと新規ユーザー登録できる' do
      expect(build(:user, name: ('a' * 30))).to be_valid
    end

    scenario 'nameが31文字では新規ユーザー登録できない' do
      expect(build(:user, name: ('a' * 31))).to_not be_valid
    end

    scenario 'emailが空では新規ユーザー登録できない' do
      expect(build(:user, email: '')).to_not be_valid
    end

    scenario 'passwordが空では新規ユーザー登録できない' do
      expect(build(:user, password: '')).to_not be_valid
    end

    scenario 'passwordが6文字の時は新規ユーザー登録できる' do
      expect(build(:user, password: ('a' * 6))).to be_valid
    end

    scenario 'passwordが5文字の時は新規ユーザー登録できない' do
      expect(build(:user, password: ('a' * 5))).to_not be_valid
    end

    scenario 'nameが空のときにバリデーションエラーメッセージが出ること' do
      visit new_user_path
      fill_in '名前', with: ''
      fill_in 'メールアドレス', with: 'aaa@example.com'
      fill_in 'パスワード', with: 'aaaaaa'
      fill_in '確認用パスワード', with: 'aaaaaa'
      click_button '登録'
      expect(page).to have_content '名前を入力してください'
    end

    scenario 'emailが空のときにバリデーションエラーメッセージが出ること' do
      visit new_user_path
      fill_in '名前', with: 'aaa'
      fill_in 'メールアドレス', with: ''
      fill_in 'パスワード', with: 'aaaaaa'
      fill_in '確認用パスワード', with: 'aaaaaa'
      click_button '登録'
      expect(page).to have_content 'メールアドレスは不正な値です'
    end

    scenario 'emailがアドレスの形式ではないときにバリデーションエラーメッセージが出ること' do
      visit new_user_path
      fill_in '名前', with: 'aaa'
      fill_in 'メールアドレス', with: 'aaaa'
      fill_in 'パスワード', with: 'aaaaaa'
      fill_in '確認用パスワード', with: 'aaaaaa'
      click_button '登録'
      expect(page).to have_content 'メールアドレスは不正な値です'
    end

    scenario 'passwordが空のときにバリデーションエラーメッセージが出ること' do
      visit new_user_path
      fill_in '名前', with: 'aaa'
      fill_in 'メールアドレス', with: 'aaa@example.com'
      fill_in 'パスワード', with: ''
      fill_in '確認用パスワード', with: 'aaaaaa'
      click_button '登録'
      expect(page).to have_content 'パスワードを入力してください'
    end

    scenario '確認用passwordが空のときにバリデーションエラーメッセージが出ること' do
      visit new_user_path
      fill_in '名前', with: 'aaa'
      fill_in 'メールアドレス', with: 'aaa@example.com'
      fill_in 'パスワード', with: 'aaaaaa'
      fill_in '確認用パスワード', with: ''
      click_button '登録'
      expect(page).to have_content '確認用パスワードとパスワードの入力が一致しません'
    end

    scenario 'passwordが確認用passwordとあっていない時にバリデーションエラーメッセージが出ること' do
      visit new_user_path
      fill_in '名前', with: 'aaa'
      fill_in 'メールアドレス', with: 'aaa@example.com'
      fill_in 'パスワード', with: 'aaaaaa'
      fill_in '確認用パスワード', with: 'bbbbbb'
      click_button '登録'
      expect(page).to have_content '確認用パスワードとパスワードの入力が一致しません'
    end
  end

  scenario '新規ユーザー登録できる' do
    expect do
      visit root_path
      click_link '新規登録'
      fill_in '名前', with: 'aaa'
      fill_in 'メールアドレス', with: 'aaa@example.com'
      fill_in 'パスワード', with: 'aaaaaa'
      click_button '登録する'
      expect(page).to have_content '登録完了しました'
    end
  end
end