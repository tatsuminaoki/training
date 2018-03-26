# frozen_string_literal: true

require 'rails_helper'

describe 'ユーザー編集画面', type: :feature do
  let!(:admin) { create(:user) }
  let!(:edit_user) { create(:user) }

  describe 'アクセス' do
    context '非ログイン状態でアクセスした場合' do
      it 'ログイン画面が表示されること' do
        visit edit_admin_user_path(edit_user)
        expect(page).to have_css('.form-signin')
      end
    end

    context 'ログイン状態でアクセスした場合' do
      it 'ユーザー編集画面が表示されること' do
        visit_after_login(user: admin, visit_path: edit_admin_user_path(edit_user))
        expect(page).to have_css('#edit_user')
      end
    end
  end

  describe '登録されているユーザー情報を表示する' do
    before { visit_after_login(user: admin, visit_path: edit_admin_user_path(edit_user)) }

    it 'ユーザー名が表示されていること' do
      expect(page.find('#user_name').value).to eq edit_user.name
    end

    it 'パスワードが表示されていないこと' do
      expect(page.find('#user_password').value).to eq ''
    end
  end

  describe 'ユーザーを更新する' do
    before { visit_after_login(user: admin, visit_path: edit_admin_user_path(edit_user)) }
    context '正常に更新できる場合' do
      it 'ユーザー名を変更して更新できること' do
        within('#edit_user') do
          fill_in I18n.t('page.user.labels.user_name'), with: 'hogehoge'
        end
        click_on I18n.t('helpers.submit.update')

        expect(page).to have_css('#users_list')
        expect(page).to have_content I18n.t('success.update', it: User.model_name.human)
      end

      it 'パスワードを変更して更新できること' do
        within('#edit_user') do
          fill_in I18n.t('page.user.labels.password'), with: 'hogehoge'
        end
        click_on I18n.t('helpers.submit.update')

        expect(page).to have_css('#users_list')
        expect(page).to have_content I18n.t('success.update', it: User.model_name.human)
      end
    end

    context '更新に失敗する場合' do
      context 'ユーザー名のバリデーション' do
        it '空白の場合、エラーメッセージが表示されること' do
          within('#edit_user') do
            fill_in I18n.t('page.user.labels.user_name'), with: ''
          end
          click_on I18n.t('helpers.submit.update')

          expect(page).to have_css('#edit_user')
          expect(page).to have_content('Nameを入力してください')
        end
      end

      context 'パスワードのバリデーション' do
        it '6文字以下の場合、エラーメッセージが表示されること' do
          within('#edit_user') do
            fill_in I18n.t('page.user.labels.password'), with: 'fooba'
          end
          click_on I18n.t('helpers.submit.update')

          expect(page).to have_css('#edit_user')
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
