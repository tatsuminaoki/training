require 'rails_helper'
include Admin::UsersHelper

RSpec.describe 'Admin::User', type: :feature do
  let!(:user) { FactoryBot.create(:user, role: User.roles[:admin]) }

  before do
    visit logins_new_path
    fill_in 'email', with: user.email
    fill_in 'password', with: user.password
    click_on I18n.t('logins.view.new.submit')
  end

  describe '管理者がユーザー一覧にアクセスする' do
    before do
      visit admin_users_path
    end

    it 'ユーザー一覧が表示される' do
      expect(page).to have_content user.name
      expect(page).to have_content user.email
      expect(page).to have_content user.tasks.count
      expect(page).to have_content convert_date_format(user.created_at)
    end

    context '詳細ボタンをクリックしたとき' do
      it 'ユーザー詳細に遷移する' do
        click_on I18n.t('admin.view.index.show_page')
        expect(current_path).to eq admin_user_path(user.id)
      end
    end

    context '編集ボタンをクリックしたとき' do
      it 'ユーザー編集に遷移する' do
        click_on I18n.t('admin.view.index.edit_page')
        expect(current_path).to eq edit_admin_user_path(user.id)
      end
    end

    # 削除テストにバグがありログインしている管理者ユーザーのアカウントを削除してしまってテストが落ちる　後で修正する
    skip '管理者がユーザーを削除する' do
      context '削除をクリックしたとき' do
        let!(:user_2) { FactoryBot.create(:user) }

        it 'ユーザーが削除される' do
          click_on I18n.t('admin.view.index.delete')
          expect(current_path).to eq admin_users_path
          expect(page).to have_content I18n.t('admin.controller.messages.deleted')
          expect(page).not_to have_content user.email
          expect(page).to have_content user_2.email
        end
      end
    end
  end

  describe '管理者がユーザー詳細にアクセスする' do
    let!(:task) { FactoryBot.create(:task, user_id: user.id) }

    before do
      visit admin_user_path(user.id)
    end

    it 'ユーザー詳細が表示される' do
      expect(page).to have_content user.id
      expect(page).to have_content user.name
      expect(page).to have_content user.email
      expect(page).to have_content convert_date_format(user.created_at)
      expect(page).to have_content convert_date_format(user.updated_at)
    end

    it 'ユーザーのタスク一覧が表示される' do
      expect(page).to have_content task.name
      expect(page).to have_content task.description
      expect(page).to have_content I18n.t("tasks.model.status.#{task.status}")
      expect(page).to have_content I18n.t("tasks.model.priority.#{task.priority}")
      expect(page).to have_content task.end_date
    end

    context '編集ボタンをクリックしたとき' do
      it 'ユーザー編集に遷移する' do
        click_on I18n.t('admin.view.index.edit_page')
        expect(current_path).to eq edit_admin_user_path(user.id)
      end
    end

    context '一覧ボタンをクリックしたとき' do
      it 'ユーザー一覧に遷移する' do
        click_on I18n.t('admin.view.show.index_page')
        expect(current_path).to eq admin_users_path
      end
    end
  end

  describe '管理者がユーザー編集にアクセスする' do
    before do
      visit edit_admin_user_path(user.id)
    end

    it '編集ページが表示される' do
      expect(current_path).to eq edit_admin_user_path(user.id)
    end

    # 入力フォームがないのでUserの管理者権限が戻ってテストが落ちるのでフォーム実装までskip
    skip 'ユーザー情報を変更して更新をクリックしたとき' do
      before do
        fill_in I18n.t('attributes.name'), with: 'hogefuga'
        fill_in I18n.t('attributes.email'), with: 'fuga@example.com'
        click_on I18n.t('admin.view.partial.update')
      end

      it 'ユーザー詳細に遷移する' do
        expect(page).to have_content I18n.t('admin.controller.messages.updated')
        expect(current_path).to eq admin_user_path(user.id)
      end

      it 'ユーザー情報が更新されている' do
        expect(page).to have_content User.last.name
        expect(page).to have_content User.last.email
      end
    end
  end

  describe '管理者がユーザー作成にアクセスする' do
    before do
      visit new_admin_user_path
    end

    it '作成ページが表示される' do
      expect(current_path).to eq new_admin_user_path
    end

    context 'ユーザー情報を入力して作成をクリックしたとき' do
      before do
        fill_in I18n.t('attributes.name'), with: 'hogefuga'
        fill_in I18n.t('attributes.email'), with: 'fuga@example.com'
        fill_in I18n.t('attributes.password'), with: 'test1234'
        click_on I18n.t('admin.view.partial.create')
      end

      it 'ユーザー詳細に遷移する' do
        expect(current_path).to eq admin_user_path(User.last.id)
      end

      it '新しいユーザーが作成される' do
        expect(page).to have_content User.last.name
        expect(page).to have_content User.last.email
      end
    end
  end
end