# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'タスク管理一覧画面', type: :feature do
  # 初期データ作成
  let!(:init_user) { create(:user) }
  let!(:init_tasks) {
    [
      create(:task, { name: 'name1', due_date: '2019-12-31', priority: :high, user: init_user, status: :closed }),
      create(:task, { name: 'name2', due_date: '2020-12-31', priority: :low, user: init_user, status: :in_progress }),
      create(:task, { name: 'name3', due_date: '2018-12-31', priority: :normal, user: init_user, status: :open }),
    ]
  }
  before do
    visit root_path
    fill_in 'user[email]', with: init_user.email
    fill_in 'user[password]', with: init_user.password
    click_button 'ログイン'
  end
  context '初期表示' do
    scenario 'タスク一覧の表示確認' do
      visit root_path
      init_tasks.each do |task|
        expect(page).to have_content task.name
        expect(page).to have_content task.description
        expect(Task.count).to eq(3)
      end
    end
    scenario 'タスク一覧のデフォルトソート順（登録日時、降順）の確認' do
      visit root_path
      names = page.all('td.name')
      expect(names[0]).to have_content 'name1'
      expect(names[1]).to have_content 'name2'
      expect(names[2]).to have_content 'name3'
    end
    scenario 'タスク一覧のソート順（期限、降順）の確認' do
      visit tasks_path(order_by: 'due_date', order: 'ASC')
      names = page.all('td.name')
      expect(names[0]).to have_content 'name3'
      expect(names[1]).to have_content 'name1'
      expect(names[2]).to have_content 'name2'
    end
    scenario 'タスク一覧のソート順（期限、昇順）の確認' do
      visit tasks_path(order_by: 'due_date', order: 'DESC')
      names = page.all('td.name')
      expect(names[0]).to have_content 'name2'
      expect(names[1]).to have_content 'name1'
      expect(names[2]).to have_content 'name3'
    end
    scenario 'タスク一覧のソート順（優先度、降順）の確認' do
      visit tasks_path(order_by: 'priority', order: 'ASC')
      names = page.all('td.name')
      expect(names[0]).to have_content 'name2'
      expect(names[1]).to have_content 'name3'
      expect(names[2]).to have_content 'name1'
    end
    scenario 'タスク一覧のソート順（優先度、昇順）の確認' do
      visit tasks_path(order_by: 'priority', order: 'DESC')
      names = page.all('td.name')
      expect(names[0]).to have_content 'name1'
      expect(names[1]).to have_content 'name3'
      expect(names[2]).to have_content 'name2'
    end
    scenario 'タスク一覧のソート順（登録日時、降順）の確認' do
      visit tasks_path(order_by: 'created_at', order: 'ASC')
      names = page.all('td.name')
      expect(names[0]).to have_content 'name3'
      expect(names[1]).to have_content 'name2'
      expect(names[2]).to have_content 'name1'
    end
    scenario 'タスク一覧のソート順（登録日時、昇順）の確認' do
      visit tasks_path(order_by: 'created_at', order: 'DESC')
      names = page.all('td.name')
      expect(names[0]).to have_content 'name1'
      expect(names[1]).to have_content 'name2'
      expect(names[2]).to have_content 'name3'
    end
  end
  context '検索・絞り込み機能テスト' do
    scenario 'タスク名で検索 1件HIT' do
      visit root_path
      fill_in 'name', with: init_tasks[0].name
      click_on('Search')
      expect(current_path).to eq tasks_path()
      expect(page).to have_content('name', count: 1)
      expect(page).to have_content('name1', count: 1)
    end
    scenario 'タスク名で検索 複数件HIT' do
      visit root_path
      fill_in 'name', with: 'name'
      click_on('Search')
      expect(current_path).to eq tasks_path()
      expect(page).to have_content('name1', count: 1)
      expect(page).to have_content('name2', count: 1)
      expect(page).to have_content('name3', count: 1)
    end
    scenario 'タスク名で検索 0件HIT' do
      visit root_path
      fill_in 'name', with: 'no_hit_task'
      click_on('Search')
      expect(current_path).to eq tasks_path()
      expect(page).not_to have_content 'name'
    end
    scenario 'ステータスで絞り込み' do
      visit root_path
      select '着手中', from: 'status'
      click_on('Search')
      expect(current_path).to eq tasks_path()
      expect(page).to have_content('name', count: 1)
      expect(page).to have_content('name2', count: 1)
    end
    scenario 'タスク名とステータスで検索' do
      visit root_path
      fill_in 'name', with: 'na'
      select '未着手', from: 'status'
      click_on('Search')
      expect(current_path).to eq tasks_path()
      expect(page).to have_content('name', count: 1)
      expect(page).to have_content('name3', count: 1)
    end
  end
end
RSpec.feature 'タスク管理 機能テスト(遷移・更新系)', type: :feature do
  let!(:init_user) { create(:user) }
  let!(:init_task) { create(:task, user: init_user) }
  before do
    visit root_path
    fill_in 'user[email]', with: init_user.email
    fill_in 'user[password]', with: init_user.password
    click_button 'ログイン'
  end
  context '画面遷移テスト' do
    scenario 'タスクの登録画面への遷移確認' do
      visit root_path
      click_on('タスク登録')
      expect(current_path).to eq new_task_path
      expect(page).to have_field 'task_name', with: ''
      expect(page).to have_field 'task_description', with: ''
    end
    scenario 'タスクの更新画面への遷移確認' do
      visit root_path
      click_link '編集', match: :first
      expect(current_path).to eq edit_task_path(init_task)
      expect(page).to have_field 'task_name', with: init_task.name
      expect(page).to have_field 'task_description', with: init_task.description
    end
  end
  context '登録・更新・削除テスト' do
    let!(:user) { create(:user) }
    let(:added_task) { build(:task, { name: 'ゴミ出し', description: '粗大ゴミ出す', user: user }) }
    let(:updated_task) { build(:task, { name: '家事', description: 'トイレ掃除', user: user }) }
    scenario 'タスクの登録確認' do
      visit new_task_path
      expect {
        fill_in 'task_name', with: added_task.name
        fill_in 'task_description', with: added_task.description
        click_on('登録')
      }.to change { Task.count }.by(1)
      expect(current_path).to eq tasks_path
      expect(page).to have_content 'タスクの登録に成功しました。'
      expect(page).to have_content added_task.name
      expect(page).to have_content added_task.description
    end
    scenario 'タスクの更新確認' do
      visit edit_task_path(init_task)
      expect {
        fill_in 'task_name', with: updated_task.name
        fill_in 'task_description', with: updated_task.description
        click_on('更新')
      }.to change { Task.count }.by(0)
      expect(current_path).to eq tasks_path
      expect(page).to have_content 'タスクの更新に成功しました。'
      expect(page).to_not have_content init_task.name
      expect(page).to_not have_content init_task.description
      expect(page).to have_content updated_task.name
      expect(page).to have_content updated_task.description
      init_task.reload
      expect(init_task.name).to eq updated_task.name
      expect(init_task.description).to eq updated_task.description
    end
    scenario 'タスクの削除確認' do
      visit root_path
      expect {
        click_link '削除', match: :first
        page.accept_confirm "#{init_task.name}を削除しますか？"
        expect(current_path).to eq tasks_path
      }.to change { Task.count }.by(-1)
      expect(page).to have_content 'タスクの削除に成功しました。'
    end
  end
end
RSpec.feature 'タスク管理 機能テスト(ページング)', type: :feature do
  let!(:user) { create(:user) }
  before do
    visit root_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'ログイン'
  end
  context '1ページ目のみ（タスク1件）の時' do
    let!(:task) { create(:task, user: user) }
    scenario 'ページングが表示されないこと' do
      visit root_path
      expect(Task.all.size).to eq(1)
      expect(page.all('td.name').count).to eq 1
      expect(page).not_to have_selector('.pagination')
    end
  end
  context '1ページ目のみ（タスク5件）の時' do
    let!(:tasks) { create_list(:task, 5, user: user) }
    scenario 'ページングが表示されないこと' do
      visit root_path
      expect(Task.all.size).to eq(5)
      expect(page.all('td.name').count).to eq 5
      expect(page).not_to have_selector('.pagination')
    end
  end
  context '2ページ分（タスク10件）のタスクがある時' do
    let!(:tasks) { create_list(:task, 10, user: user) }
    scenario '1ページ目のページングが適切に表示されること' do
      visit root_path
      expect(page.all('td.name').count).to eq 5
      expect(page).to have_selector('.pagination')
      expect(page).to_not have_content '« 最初'
      expect(page).to_not have_content '‹ 前'
      expect(page).to have_content '次 ›'
      expect(page).to have_content '最後 »'
    end
    scenario '2ページ目のページングが適切に表示されること' do
      visit tasks_path(page: 2)
      expect(page.all('td.name').count).to eq 5
      expect(page).to have_selector('.pagination')
      expect(page).to have_content '« 最初'
      expect(page).to have_content '‹ 前'
      expect(page).to_not have_content '次 ›'
      expect(page).to_not have_content '最後 »'
    end
  end
  context '3ページ分（タスク12件）のタスクがある時' do
    let!(:tasks) { 12.times { |i| create(:task, name: "Task Name #{i}", user: user) } }
    scenario '1ページ目のページングが適切に表示されること' do
      visit root_path
      expect(page.all('td.name').count).to eq 5
      expect(page).to have_selector('.pagination')
      expect(page).to_not have_content '« 最初'
      expect(page).to_not have_content '‹ 前'
      expect(page).to have_content '次 ›'
      expect(page).to have_content '最後 »'
      expect(page.all('td.name').count).to eq 5
      0.upto(4) { |i| expect(page).to have_content("Task Name #{i}", count: 1) }
    end
    scenario '2ページ目のページングが適切に表示されること' do
      visit root_path(page: 2)
      expect(page.all('td.name').count).to eq 5
      expect(page).to have_selector('.pagination')
      expect(page).to have_content '« 最初'
      expect(page).to have_content '‹ 前'
      expect(page).to have_content '次 ›'
      expect(page).to have_content '最後 »'
      expect(page.all('td.name').count).to eq 5
      5.upto(9) { |i| expect(page).to have_content("Task Name #{i}", count: 1) }
    end
    scenario '3ページ目のページングが適切に表示されること' do
      visit root_path(page: 3)
      expect(page.all('td.name').count).to eq 2
      expect(page).to have_selector('.pagination')
      expect(page).to have_content '« 最初'
      expect(page).to have_content '‹ 前'
      expect(page).to_not have_content '次 ›'
      expect(page).to_not have_content '最後 »'
      expect(page.all('td.name').count).to eq 2
      10.upto(11) { |i| expect(page).to have_content("Task Name #{i}", count: 1) }
    end
    scenario '1ページ目の「2」リンクで2ページ目に遷移できること' do
      visit root_path
      find(:css, '.page-item > a', text: '2').click
      uri = URI.parse(current_url)
      expect("#{uri.path}?#{uri.query}").to eq root_path(page: 2)
    end
    scenario '1ページ目の「次」リンクで2ページ目に遷移できること' do
      visit root_path
      find(:css, '.page-item > a', text: '次').click
      uri = URI.parse(current_url)
      expect("#{uri.path}?#{uri.query}").to eq root_path(page: 2)
    end
    scenario '1ページ目の「最後」リンクで3ページ目に遷移できること' do
      visit root_path
      find(:css, '.page-item > a', text: '最後').click
      uri = URI.parse(current_url)
      expect("#{uri.path}?#{uri.query}").to eq root_path(page: 3)
    end
    scenario '2ページ目の「最初」リンクで1ページ目に遷移できること' do
      visit root_path(page: 2)
      find(:css, '.page-item > a', text: '最初').click
      expect(current_path).to eq root_path
    end
    scenario '2ページ目の「前」リンクで1ページ目に遷移できること' do
      visit root_path(page: 2)
      find(:css, '.page-item > a', text: '前').click
      expect(current_path).to eq root_path
    end
    scenario '2ページ目の「次」リンクで3ページ目に遷移できること' do
      visit root_path(page: 2)
      find(:css, '.page-item > a', text: '次').click
      uri = URI.parse(current_url)
      expect("#{uri.path}?#{uri.query}").to eq root_path(page: 3)
    end
    scenario '2ページ目の「最後」リンクで3ページ目に遷移できること' do
      visit root_path(page: 2)
      find(:css, '.page-item > a', text: '最後').click
      uri = URI.parse(current_url)
      expect("#{uri.path}?#{uri.query}").to eq root_path(page: 3)
    end
    scenario '3ページ目の「最初」リンクで1ページ目に遷移できること' do
      visit root_path(page: 3)
      find(:css, '.page-item > a', text: '最初').click
      expect(current_path).to eq root_path
    end
    scenario '3ページ目の「前」リンクで2ページ目に遷移できること' do
      visit root_path(page: 3)
      find(:css, '.page-item > a', text: '前').click
      uri = URI.parse(current_url)
      expect("#{uri.path}?#{uri.query}").to eq root_path(page: 2)
    end
  end
end
