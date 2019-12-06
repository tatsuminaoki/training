# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :system do

  describe "when sign up" do
    context "success" do
      it "with valid attribute" do
        visit signup_path
        fill_in 'user_name', with: 'test_user'
        fill_in 'user_password', with: 'test_password'
        fill_in 'user_password_confirmation', with: 'test_password'
        click_on '登録'
        expect(page).to have_content 'Success!'
      end
    end

    context "failed" do
      it "with no name" do
        visit signup_path
        fill_in 'user_password', with: 'test_password'
        fill_in 'user_password_confirmation', with: 'test_password'
        click_on '登録'
        expect(page).to have_content '名前を入力してください'
      end

      it "with no password" do
        visit signup_path
        fill_in 'user_name', with: 'test_user'
        fill_in 'user_password_confirmation', with: 'test_password'
        click_on '登録'
        expect(page).to have_content 'パスワードを入力してください'
      end

      it "with no password_confirmation" do
        visit signup_path
        fill_in 'user_name', with: 'test_user'
        fill_in 'user_password', with: 'test_password'
        click_on '登録'
        expect(page).to have_content 'パスワード確認とパスワードの入力が一致しません'
      end

      it "with invalid password_confirmation" do
        visit signup_path
        fill_in 'user_name', with: 'test_user'
        fill_in 'user_password', with: 'test_password'
        fill_in 'user_password_confirmation', with: 'wrong_password'
        click_on '登録'
        expect(page).to have_content 'パスワード確認とパスワードの入力が一致しません'
      end
    end
  end

end
