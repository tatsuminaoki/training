# frozen_string_literal: true

require 'rails_helper'

describe 'タスク一覧画面', type: :feature do
  describe '画面にアクセス' do
    it 'ルートパスでアクセスできること' do
      visit root_path
      expect(page).to have_css('#todo_app_task_list')
    end
  end

  context '1件タスクが登録されている場合' do
    before do
      create(:task, title: 'Rspec test 1')
      visit root_path
    end

    let!(:record) { first(:css, 'table#task_table tbody tr') }

    it '登録した1件のタスクがテーブルに表示されていること' do
      expect(page).to have_css('table#task_table tbody tr', count: 1)
    end

    it 'タイトル列に参照画面のリンクが表示されていること' do
      expect(record).to have_selector('a', text: 'Rspec test 1')
    end

    it '編集列の編集画面のリンクが表示されていること' do
      expect(record).to have_selector('a.edit-button')
    end

    it '削除列に削除ボタンが表示されていること' do
      expect(record).to have_selector('a.trash-button')
    end
  end

  context '複数のタスクが登録されている場合', type: :feature do
    before do
      (1..10).to_a.each { |i| create(:task, title: "Rspec test #{i}", created_at: "2018/1/1 0:0:#{i}") }
      visit root_path
    end

    context '初期表示の場合' do
      it '絞り込み条件なしで全てのデータがテーブルに表示されていること' do
        expect(page).to have_css('table#task_table tbody tr', count: 10)
      end

      it 'created_atの降順で表示されていること' do
        all('table#task_table tbody tr').reverse_each.with_index do |td, idx|
          # 作成時に登録順でインクリメントしているので、idでソートされていると名前も昇順になっている
          expect(td).to have_selector('a', text: "Rspec test #{idx + 1}")
        end
      end
    end
  end

  describe '画面の表示内容を変更する' do
    describe 'ソート順を変更する' do
      before do
        (1..10).to_a.each { |i| create(:task, title: "Rspec test #{i}", deadline: "2018/2/#{11 - i} 01:01:01", created_at: "2018/1/1 0:0:#{i}") }
        visit root_path
        within('.card-text') { select Task.human_attribute_name("sort_kinds.#{sort}"), from: 'search_sort' }
        click_on I18n.t('helpers.submit.search')
      end

      context '新着順でソートしたい場合' do
        let (:sort) { 'created_at' }

        it 'created_atの降順で表示されていること' do
          all('table#task_table tbody tr').each.with_index do |td, idx|
            expect(td).to have_content("2018/01/01 00:00:#{format('%02d', 10 - idx)}")
          end
          expect(page.find('#search_sort').value).to eq 'created_at'
        end
      end

      context '期日が近い順でソートしたい場合' do
        let (:sort) { 'deadline' }

        it 'deadlineの降順で表示されていること' do
          all('table#task_table tbody tr').each.with_index do |td, idx|
            expect(td).to have_content("2018/02/#{format('%02d', 10 - idx)} 01:01:01")
          end
          expect(page.find('#search_sort').value).to eq 'deadline'
        end
      end
    end

    describe '一覧を絞り込む' do
      context 'タイトルで絞り込みたい場合' do
        before do
          (1..10).to_a.each { |i| create(:task, title: "Rspec test #{i}", status: 'not_start') }
          visit root_path
          within('.card-text') { fill_in I18n.t('page.task.labels.title'), with: 'Rspec test 1' }
          click_on I18n.t('helpers.submit.search')
        end

        it '入力値に完全に一致するタスクのみ表示されていること' do
          expect(page).to have_css('table#task_table tbody tr', count: 1)
          expect(first('table#task_table tbody tr')).to have_link('Rspec test 1')
        end

        it '入力したタイトルが検索後の画面で表示されていること' do
          expect(page.find('#search_title').value).to eq 'Rspec test 1'
        end
      end

      context 'ステータスで絞り込みたい場合' do
        before do
          (1..10).to_a.each { |i| create(:task, status: (i.even? ? 'not_start' : 'done')) }
          visit root_path
          within('.card-text') { select Task.human_attribute_name('statuses.done'), from: 'search_status' }
          click_on I18n.t('helpers.submit.search')
        end

        it '選択したステータスに完全に一致するタスクのみ表示されていること' do
          expect(page).to have_css('table#task_table tbody tr', count: 5)
          all('table#task_table tbody tr').each do |td|
            expect(td).to have_content(Task.human_attribute_name('statuses.done'))
          end
        end

        it '入力したステータスが検索後の画面で表示されていること' do
          expect(page.find('#search_status').value).to eq 'done'
        end
      end

      context 'タイトルとステータスで絞り込みたい場合' do
        before do
          (1..10).to_a.each { |i| create(:task, title: "Rspec test #{i}", status: (i.even? ? 'not_start' : 'done')) }
          visit root_path
          within('.card-text') do
            fill_in I18n.t('page.task.labels.title'), with: 'Rspec test 1'
            select Task.human_attribute_name('statuses.done'), from: 'search_status'
          end
          click_on I18n.t('helpers.submit.search')
        end

        it '選択したタイトルとステータスに完全に一致するタスクのみ表示されていること' do
          expect(page).to have_css('table#task_table tbody tr', count: 1)
          expect(first('table#task_table tbody tr')).to have_link('Rspec test 1')
          expect(first('table#task_table tbody tr')).to have_content(Task.human_attribute_name('statuses.done'))
        end
      end
    end
  end

  context 'タスクを登録したい場合' do
    before { visit root_path }
    it '作成ボタンが表示されること' do
      expect(page).to have_button('add_task_button')
    end

    it 'タスク登録画面へ遷移できること' do
      click_on 'add_task_button'
      expect(page).to have_selector(:css, '#add_task')
    end
  end

  describe 'タスクの詳細・編集画面への遷移' do
    before do
      create(:task, title: 'Rspec test 1')
      visit root_path
    end

    context 'タスク詳細画面へ遷移したい場合' do
      it 'タスク名のリンククリックで遷移できること' do
        first(:css, 'table#task_table tbody tr').find_link('Rspec test 1').click
        expect(page).to have_selector(:css, '#show_task')
      end
    end

    context 'タスク編集画面へ遷移したい場合' do
      it '編集アイコンをクリックで遷移できること' do
        first(:css, 'table#task_table tbody tr').find('td a.edit-button').click
        expect(page).to have_selector(:css, '#edit_task')
      end
    end
  end

  context 'タスクの削除したい場合', type: :feature do
    before do
      create(:task, title: 'Rspec test 1')
      visit root_path
      first(:css, 'table#task_table tbody tr').find('td a.trash-button').click
    end

    context '確認ダイアログでキャンセルボタンを押した場合' do
      it '対象行は削除されないこと' do
        page.dismiss_confirm
        expect(page).to have_css('table#task_table tbody tr', count: 1)
      end
    end

    context '確認ダイアログで確認ボタンを押した場合' do
      it '処理が実行されタスクが削除されること' do
        page.accept_confirm
        expect(page).to have_css('.alert-success')
        expect(page).to have_css('table#task_table tbody tr', count: 0)
      end
    end
  end
end
