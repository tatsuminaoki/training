# frozen_string_literal: true

require 'rails_helper'

describe 'ユーザー登録画面', type: :feature do
  let(:admin) { create(:user) }

  describe 'アクセス' do
    context '非ログイン状態でアクセスした場合' do
      it 'ログイン画面が表示されること' do
        visit new_admin_user_path
        expect(page).to have_css('.form-signin')
      end
    end

    context 'ログイン状態でアクセスした場合' do
      it 'ユーザー登録画面が表示されること' do
        visit_after_login(user: admin, visit_path: new_admin_user_path)
        expect(page).to have_css('#add_user')
      end
    end
  end

  describe 'ユーザーを登録する' do
    before { visit_after_login(user: admin, visit_path: new_admin_user_path) }

    context '正常に登録できる場合' do
      it 'ユーザーが登録できること' do
        within('#add_user') do
          fill_in I18n.t('page.user.labels.user_name'), with: 'hoge'
          fill_in I18n.t('page.user.labels.password'), with: 'foobar'
        end
        click_on I18n.t('helpers.submit.create')

        expect(page).to have_css('#users_list')
        expect(page).to have_content I18n.t('success.create', it: User.model_name.human)
      end
    end

    context '登録に失敗する場合' do
      context 'ユーザー名のバリデーション' do
        it '空白の場合、エラーメッセージが表示されること' do
          within('#add_user') do
            fill_in I18n.t('page.user.labels.user_name'), with: ''
            fill_in I18n.t('page.user.labels.password'), with: 'foobar'
          end
          click_on I18n.t('helpers.submit.create')

          expect(page).to have_css('#add_user')
          expect(page).to have_content('Nameを入力してください')
        end
      end

      context 'パスワードのバリデーション' do
        it '空白の場合、エラーメッセージが表示されること' do
          within('#add_user') do
            fill_in I18n.t('page.user.labels.user_name'), with: 'admin'
            fill_in I18n.t('page.user.labels.password'), with: ''
          end
          click_on I18n.t('helpers.submit.create')

          expect(page).to have_css('#add_user')
          expect(page).to have_content('Passwordを入力してください')
        end

        it '6文字以下の場合、エラーメッセージが表示されること' do
          within('#add_user') do
            fill_in I18n.t('page.user.labels.user_name'), with: 'admin'
            fill_in I18n.t('page.user.labels.password'), with: 'fooba'
          end
          click_on I18n.t('helpers.submit.create')

          expect(page).to have_css('#add_user')
          expect(page).to have_content('Passwordは6文字以上で入力してください')
        end
      end
    end

    context '登録をやめたい場合' do
      it 'キャンセルボタンクリックで一覧画面に戻れること' do
        click_on I18n.t('helpers.submit.cancel')
        expect(page).to have_css('#users_list')
      end
    end
  end
end
