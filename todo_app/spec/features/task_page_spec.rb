# frozen_string_literal: true

require 'rails_helper'

describe 'タスク一覧画面', type: :feature do
  let!(:user) { create(:user) }

  before { visit_after_login(user: user, visit_path: root_path) }

  describe 'アクセス' do
    context '非ログイン状態でアクセスした場合' do
      it 'ログイン画面が表示されること' do
        visit_without_login(visit_path: root_path)
        expect(page).to have_css('.form-signin')
      end
    end

    context 'ログイン状態でアクセスした場合' do
      it 'タスク一覧画面が表示されること' do
        expect(page).to have_css('#todo_app_task_list')
      end
    end
  end

  describe 'タスクの表示権限の検証' do
    let(:record) { first(:css, 'table#task_table tbody tr') }

    before do
      create(:task, user_id: user.id, title: 'Rspec test 1', status: 'not_start')
      visit root_path
    end

    context 'タスクの登録ユーザーの場合' do
      it '登録した1件のタスクがテーブルに表示されていること' do
        expect(page).to have_css('table#task_table tbody tr', count: 1)
      end
    end

    context 'タスクの非登録ユーザーの場合' do
      it '自分が登録していないタスクは閲覧できないこと' do
        user = User.create(name: 'some', password: 'foobar', password_confirmation: 'foobar')
        login(user: user)
        visit root_path
        expect(page).to have_css('table#task_table tbody tr', count: 0)
      end
    end
  end

  describe 'タスクの表示内容の検証' do
    before do
      (1..100).to_a.each { |i| create(:task, user_id: user.id, title: "Rspec test #{i}", created_at: Time.new('2018/01/01 00:00:00').getlocal + i) }
      visit root_path
    end

    let!(:last_create_at) { Time.new('2018/01/01 00:00:00').getlocal + 100 }

    let(:record) { first(:css, 'table#task_table tbody tr') }

    context '初期表示の場合' do
      it '絞り込み条件なしで上位10件のデータがテーブルに表示されていること' do
        expect(page).to have_css('table#task_table tbody tr', count: 10)
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

      it 'created_atの降順で表示されていること' do
        all('table#task_table tbody tr').each.with_index do |td, idx|
          expect(td).to have_content((last_create_at - idx).to_s)
        end
      end

      it 'ページをクリックすると次の10件が取得できること' do
        first('.page-item a[rel="next"]').click
        all('table#task_table tbody tr').each.with_index do |td, idx|
          expect(td).to have_content((last_create_at - idx - 10).to_s)
        end
      end
    end
  end

  describe 'ページングのカスタマイズ部分の確認' do
    before do
      (1..100).to_a.each { |i| create(:task, user_id: user.id, title: "Rspec test #{i}") }
      visit root_path
    end

    let(:label) { ApplicationController.helpers.sanitize(I18n.t("views.pagination.#{target}")) }

    context 'firstボタンの挙動' do
      let(:target) { 'first' }

      it '1ページ目を表示した際、非活性状態になっていること' do
        expect(all('.pagination li.disabled')[0]).to have_content(label)
      end

      it '2ページ目を表示した際、活性状態になっていること' do
        find('.pagination').find_link('2').click
        expect(all('.pagination li')[0]).to have_content(label)
      end
    end

    context 'previousボタンの挙動' do
      let(:target) { 'previous' }

      it '1ページ目を表示した際、非活性状態になっていること' do
        expect(all('.pagination li.disabled')[1]).to have_content(label)
      end

      it '2ページ目を表示した際、活性状態になっていること' do
        find('.pagination').find_link('2').click
        expect(all('.pagination li')[1]).to have_content(label)
      end
    end

    context 'nextボタンの挙動' do
      let(:target) { 'next' }

      it '1ページ目を表示した際、活性状態になっていること' do
        list = all('.pagination li')
        expect(list[list.size - 2]).to have_content(label)
      end

      it '最後のページ目を表示した際、非活性状態になっていること' do
        list = all('.pagination li')
        list[list.size - 1].click

        disable_list = all('.pagination li.disabled')
        expect(disable_list[disable_list.size - 2]).to have_content(label)
      end
    end

    context 'lastボタンの挙動' do
      let(:target) { 'last' }

      it '1ページ目を表示した際、活性状態になっていること' do
        list = all('.pagination li')
        expect(list[list.size - 1]).to have_content(label)
      end

      it '最後のページ目を表示した際、非活性状態になっていること' do
        find('.pagination').find_link(label).click
        list = all('.pagination li.disabled')
        expect(list[list.size - 1]).to have_content(label)
      end
    end
  end

  describe '画面の表示内容を変更する' do
    describe 'ソート順を変更する' do
      let!(:user) { create(:user) }

      context '新着順でソートしたい場合' do
        before do
          (1..10).to_a.each { |i| create(:task, user_id: user.id, title: "Rspec test #{i}", created_at: "2018/1/1 0:0:#{i}") }
          visit root_path
        end

        it 'created_atの降順で表示されていること' do
          click_sort_pulldown('created_at')
          all('table#task_table tbody tr').each.with_index do |td, idx|
            expect(td).to have_content("2018/01/01 00:00:#{format('%02d', 10 - idx)}")
          end
          expect(page.find('#search_sort', visible: false).value).to eq 'created_at'
        end
      end

      context '期日が近い順でソートしたい場合' do
        before do
          (1..10).to_a.each { |i| create(:task, user_id: user.id, title: "Rspec test #{i}", deadline: "2018/2/#{i} 01:01:01") }
          visit root_path
        end

        it 'deadlineの昇順で表示されていること' do
          click_sort_pulldown('deadline')
          all('table#task_table tbody tr').each.with_index do |td, idx|
            expect(td).to have_content("2018/02/#{format('%02d', idx + 1)} 01:01:01")
          end
          expect(page.find('#search_sort', visible: false).value).to eq 'deadline'
        end
      end

      context '優先度が高い順でソートしたい場合' do
        before do
          (0..4).to_a.each { |i| create(:task, user_id: user.id, title: "Rspec test #{i}", priority: i) }
          visit root_path
        end

        let(:priorities) { Task.priorities.keys.reverse }

        it 'priorityの降順で表示されていること' do
          click_sort_pulldown('priority')
          all('table#task_table tbody tr').each.with_index do |td, idx|
            expect(td).to have_content(Task.human_attribute_name("priorities.#{priorities[idx]}"))
          end
          expect(page.find('#search_sort', visible: false).value).to eq 'priority'
        end
      end
    end

    describe '一覧を絞り込む' do
      let(:task_title) { 'Rspec test 1' }

      context 'タイトルで絞り込みたい場合' do
        before do
          (1..10).to_a.each { |i| create(:task, user_id: user.id, title: "Rspec test #{i}", status: 'not_start') }
          visit root_path
          title_search(task_title)
        end

        it '入力値に完全に一致するタスクのみ表示されていること' do
          expect(page).to have_css('table#task_table tbody tr', count: 1)
          expect(first('table#task_table tbody tr')).to have_link(task_title)
        end

        it '入力したタイトルが検索後の画面で表示されていること' do
          expect(page.find('#search_title', visible: false).value).to eq task_title
        end
      end

      context 'ステータスで絞り込みたい場合' do
        before do
          (1..10).to_a.each { |i| create(:task, user_id: user.id, status: (i.even? ? 'not_start' : 'done')) }
          visit root_path
          find(:css, '.fa-search').click
          within('#search_modal .modal-body') { select Task.human_attribute_name('statuses.done'), from: 'search_status' }
          click_on I18n.t('helpers.submit.search')
        end

        it '選択したステータスに完全に一致するタスクのみ表示されていること' do
          expect(page).to have_css('table#task_table tbody tr', count: 5)
          all('table#task_table tbody tr').each do |td|
            expect(td).to have_content(Task.human_attribute_name('statuses.done'))
          end
        end

        it '入力したステータスが検索後の画面で表示されていること' do
          expect(page.find('#search_status', visible: false).value).to eq 'done'
        end
      end

      context 'ステータスで絞り込まない場合' do
        before do
          (1..10).to_a.each { |i| create(:task, user_id: user.id, status: (i.even? ? 'not_start' : 'done')) }
          visit root_path
          find(:css, '.fa-search').click
          within('#search_modal .modal-body') { select '', from: 'search_status' }
          click_on I18n.t('helpers.submit.search')
        end

        it '空白行を選択した場合、絞り込みが行われず全てのタスクが表示されていること' do
          expect(page).to have_css('table#task_table tbody tr', count: 10)
        end
      end

      context 'タイトルとステータスで絞り込みたい場合' do
        before do
          (1..10).to_a.each { |i| create(:task, user_id: user.id, title: "Rspec test #{i}", status: (i.even? ? 'not_start' : 'done')) }
          visit root_path
          find(:css, '.fa-search').click
          within('#search_modal .modal-body') do
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

  describe 'タスクの操作' do
    before do
      create(:task, user_id: user.id, title: 'Rspec test 1')
      visit root_path
    end

    context 'タスクを登録したい場合' do
      it '作成ボタンが表示されること' do
        expect(page).to have_button('add_task_button')
      end

      it 'タスク登録画面へ遷移できること' do
        click_on 'add_task_button'
        expect(page).to have_selector(:css, '#add_task')
      end
    end

    describe 'タスクの詳細・編集画面への遷移' do
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
end
