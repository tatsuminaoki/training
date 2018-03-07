require 'spec_helper'
require 'rails_helper'

describe 'タスク一覧画面を表示する', type: :feature do
  before { create(:task, title: "Rspec test 1" ) }
  after do
    task = Task.find_by(title: "Rspec test 1")
    task.destroy
  end

  it '表示確認' do
    visit '/'
    expect(page).to have_css('#todo_app_task_list')
  end

  it '作成ボタンの表示' do
    visit '/'
    expect(page).to have_button'add_task_button'
  end

  it '登録した1件のタスクがテーブルに表示されていること' do
    visit '/'
    expect(page).to have_css('table#task_table tbody tr', :count=>1)
  end

  it 'タイトル列に参照画面のリンク表示' do
    visit '/'
    first_record = find(:css, 'table#task_table').all('tbody tr')[0]
    expect(first_record).to have_selector('a', text: 'Rspec test 1')
  end

  it '編集画面のリンク表示' do
    visit '/'
    first_record = find(:css, 'table#task_table').all('tbody tr')[0]
    expect(first_record).to have_selector('a.edit-button')
  end

  it '削除ボタンの表示' do
    visit '/'
    first_record = find(:css, 'table#task_table').all('tbody tr')[0]
    expect(first_record).to have_selector('a.trash-button')
  end
end

# describe '複数レコードの表示する', type: :feature do
#
#   it '件数の確認' do
#
#   end
# end
#
# describe 'タスク登録画面に遷移する', type: :feature do
#   it 'タスク登録画面への遷移' do
#     visit '/'
#     click_on 'add_task_button'
#     expect(page).to have_selector(:css, "#add_task")
#   end
# end


=begin
describe 'タスク参照画面に遷移する', type: :feature do
  let!(:task) { create(:task) }

  it 'タスク登録画面への遷移' do
    visit '/'
    click_on 'open_task_registration'
    expect(page).to have_selector(:css, "#show_task")
  end
end

describe 'タスク編集画面に遷移する', type: :feature do
  let!(:task) { create(:task) }

  it 'タスク登録画面への遷移' do
    visit '/'
    click_on 'open_task_registration'
    expect(page).to have_selector(:css, "#todo_app_task_registration")
  end
end

describe 'タスクを削除する', type: :feature do
  let!(:task) { create(:task) }

  it 'タスク登録画面への遷移' do
    visit '/'
    click_on 'open_task_registration'
    expect(page).to have_selector(:css, "#todo_app_task_registration")
  end
end
=end