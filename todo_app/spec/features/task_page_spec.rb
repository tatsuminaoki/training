require 'rails_helper'

describe 'タスク一覧画面', type: :feature do

  describe '画面にアクセス' do
    it 'ルートパスでアクセスできること' do
      visit '/'
      expect(page).to have_css('#todo_app_task_list')
    end
  end

  context '1件タスクが登録されている場合' do
    before { create(:task, title: 'Rspec test 1') }

    it '登録した1件のタスクがテーブルに表示されていること' do
      visit '/'
      expect(page).to have_css('table#task_table tbody tr', count: 1)
    end

    it 'タイトル列に参照画面のリンクが表示されていること' do
      visit '/'
      tr = first(:css, 'table#task_table tbody tr')
      expect(tr).to have_selector('a', text: 'Rspec test 1')
    end

    it '編集列の編集画面のリンクが表示されていること' do
      visit '/'
      tr = first(:css, 'table#task_table tbody tr')
      expect(tr).to have_selector('a.edit-button')
    end

    it '削除列に削除ボタンが表示されていること' do
      visit '/'
      tr = first(:css, 'table#task_table tbody tr')
      expect(tr).to have_selector('a.trash-button')
    end
  end

  context '複数のタスクが登録されている場合', type: :feature do
    before do
      (1..10).to_a.each {|i| create(:task, title: "Rspec test #{i}" )}
    end

    it '複数行がテーブルに表示されていること' do
      visit '/'
      expect(page).to have_css('table#task_table tbody tr', count: 10)
    end

    it 'id順で昇順ソートされていること' do
      visit '/'
      all('table#task_table tbody tr').each.with_index do |td, idx|
        # 作成時に登録順でインクリメントしているので、idでソートされていると名前も昇順になっている
        expect(td).to have_selector('a', text: "Rspec test #{idx+1}")
      end
    end
  end

  context 'タスクを登録したい場合' do

    it '作成ボタンが表示されること' do
      visit '/'
      expect(page).to have_button('add_task_button')
    end

    it 'タスク登録画面へ遷移できること' do
      visit '/'
      click_on 'add_task_button'
      expect(page).to have_selector(:css, '#add_task')
    end
  end

  context 'タスクを編集したい場合' do
    before { create(:task, title: 'Rspec test 1') }

    it 'タスク詳細画面へ遷移できること' do
      visit '/'
      first(:css, 'table#task_table tbody tr').find_link('Rspec test 1').click
      expect(page).to have_selector(:css, '#show_task')
    end

    it 'タスク編集画面へ遷移できること' do
      visit '/'
      first(:css, 'table#task_table tbody tr').find('td a.edit-button').click
      expect(page).to have_selector(:css, '#edit_task')
    end
  end

  context 'タスクの削除したい場合', type: :feature do
    before { create(:task, title: 'Rspec test 1' ) }

    context '確認ダイアログでキャンセルボタンを押した場合' do
      it '対象行は削除されないこと' do
        visit '/'

        expect(page).to have_css('table#task_table tbody tr', count: 1)
        first(:css, 'table#task_table tbody tr').find('td a.trash-button').click
        page.dismiss_confirm

        expect(page).to have_css('table#task_table tbody tr', count: 1)
      end
    end

    context '確認ダイアログで確認ボタンを押した場合' do
      it '処理が実行されタスクが削除されること' do
        visit '/'

        expect(page).to have_css('table#task_table tbody tr', count: 1)
        first(:css, 'table#task_table tbody tr').find('td a.trash-button').click
        page.accept_confirm

        expect(page).to have_css('.alert-success')
        expect(page).to have_css('table#task_table tbody tr', count: 0)
      end
    end
  end
end
