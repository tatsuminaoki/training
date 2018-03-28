# frozen_string_literal: true

require 'rails_helper'

describe 'ユーザー一覧画面', type: :feature do
  let(:created_users) { (1..5).map { create(:user) } }
  let(:admin) { created_users.first }
  let(:first_user) { created_users.sort_by(&:name).first }

  describe 'アクセス' do
    context '非ログイン状態でアクセスした場合' do
      it 'ログイン画面が表示されること' do
        visit admin_users_path
        expect(page).to have_css('.form-signin')
      end
    end

    context 'ログイン状態でアクセスした場合' do
      it 'ユーザー一覧画面が表示されること' do
        visit_after_login(user: admin, visit_path: admin_users_path)
        expect(page).to have_css('#users_list')
      end
    end
  end

  describe 'ユーザーの表示内容の検証' do
    before { visit_after_login(user: admin, visit_path: admin_users_path) }

    describe '初期表示の描画確認' do
      context 'メニューの検証' do
        it '左側メニューにリンクが表示されていること' do
          menus = all('.list-group-item')
          expect(menus.size).to eq 2
          expect(menus[0]).to have_content(I18n.t('page.user.titles.list'))
          expect(menus[1]).to have_content(I18n.t('page.user.titles.new'))
        end

        it 'ユーザーリンクがactive状態になっていること' do
          menus = all('.list-group-item.active')
          expect(menus.size).to eq 1
          expect(menus[0]).to have_content(I18n.t('page.user.titles.list'))
        end
      end

      context '一覧表の検証' do
        before do
          10.times { create(:task, user_id: first_user.id) }
          visit admin_users_path
        end

        let(:record) { all('#user_table tbody tr').first }

        it 'ユーザー名欄にユーザー名が表示されていること' do
          expect(record).to have_content(first_user.name)
        end

        it 'タスク数欄にユーザーが作成したタスク数が表示されていること' do
          expect(record).to have_selector('a', text: first_user.tasks.count)
        end

        it '登録日時欄にユーザーの登録日時が表示されていること' do
          expect(record).to have_content(first_user.created_at.to_s)
        end

        it '編集列の編集画面のリンクが表示されていること' do
          expect(record).to have_selector('a.edit-button')
        end

        it '削除列に削除ボタンが表示されていること' do
          expect(record).to have_selector('a.trash-button')
        end
      end
    end
  end

  describe '一覧を絞り込む' do
    before { visit_after_login(user: admin, visit_path: admin_users_path) }

    context 'ユーザー名で絞り込みたい場合' do
      before do
        find(:css, '.fa-search').click
        within('#search_modal .modal-body') { fill_in I18n.t('page.user.labels.user_name'), with: first_user.name }
        click_on I18n.t('helpers.submit.search')
      end

      it '入力値に完全に一致するユーザーのみ表示されていること' do
        expect(page).to have_css('#user_table tbody tr', count: 1)
        expect(first('#user_table tbody tr')).to have_content(first_user.name)
      end

      it '入力したユーザー名が検索後の画面で表示されていること' do
        expect(page.find('#search_name', visible: false).value).to eq first_user.name
      end
    end
  end

  describe 'ユーザーの操作' do
    before { visit_after_login(user: admin, visit_path: admin_users_path) }
    let(:record) { all('#user_table tbody tr').first }

    it 'ユーザー登録画面に遷移できること' do
      all('.list-group-item')[1].click
      expect(page).to have_selector(:css, '#add_user')
    end

    it 'ユーザー編集画面に遷移できること' do
      record.find('a.edit-button').click
      expect(page).to have_selector(:css, '#edit_user')
    end

    it 'ユーザーのタスク一覧画面に遷移できること' do
      record.all('td a')[0].click
      expect(page).to have_selector(:css, '#task_list')
    end

    context 'ユーザーを削除したい場合', type: :feature do
      let(:record) { all('#user_table tbody tr')[1] }
      let!(:delete_user) { created_users.sort_by(&:name)[1] }
      let!(:initial_count) { User.count }

      before { record.find('a.trash-button').click }

      context '確認ダイアログでキャンセルボタンを押した場合' do
        it '対象行は削除されず、一覧画面に戻ること' do
          page.dismiss_confirm
          expect(page).to have_css('#users_list')
          expect(page).to have_no_css('.alert-success')
          expect(page).to have_css('#user_table tbody tr', count: initial_count)
        end
      end

      context '確認ダイアログで確認ボタンを押した場合' do
        let!(:user_task) { create(:task, user_id: delete_user.id) }

        it '削除処理が実行され、タスク一覧画面に成功メッセージが表示されること' do
          page.accept_confirm
          expect(page).to have_css('#users_list')
          expect(page).to have_css('.alert-success')
          expect(page).to have_css('#user_table tbody tr', count: initial_count - 1)
          expect(Task.where(user_id: delete_user.id).count.zero?).to be_truthy
        end
      end
    end
  end
end
