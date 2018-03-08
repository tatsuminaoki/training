require 'spec_helper'
require 'rails_helper'

describe 'タスク一覧画面を表示する', type: :feature do
  before { create(:task, title: 'Rspec test 1') }

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
    expect(page).to have_css('table#task_table tbody tr', count: 1)
  end

  it 'タイトル列に参照画面のリンク表示' do
    visit '/'
    tr = first(:css, 'table#task_table tbody tr')
    expect(tr).to have_selector('a', text: 'Rspec test 1')
  end

  it '編集画面のリンク表示' do
    visit '/'
    tr = first(:css, 'table#task_table tbody tr')
    expect(tr).to have_selector('a.edit-button')
  end

  it '削除ボタンの表示' do
    visit '/'
    tr = first(:css, 'table#task_table tbody tr')
    expect(tr).to have_selector('a.trash-button')
  end
end

describe '複数レコードの表示する', type: :feature do
  before do
    (1..10).to_a.each {|i| create(:task, title: "Rspec test #{i}" )}
  end

  it '件数の確認' do
    visit '/'
    expect(page).to have_css('table#task_table tbody tr', count: 10)
  end

  it 'id順で昇順ソートされていることの確認' do
    visit '/'
    all('table#task_table tbody tr').each.with_index do |td, idx|
      # 作成時に登録順でインクリメントしているので、idでソートされていると名前も昇順になっている
      expect(td).to have_selector('a', text: "Rspec test #{idx+1}")
    end
  end

end

describe 'タスク一覧画面から別画面に遷移する', type: :feature do
  before { create(:task, title: 'Rspec test 1' ) }

  it 'タスク登録画面への遷移' do
    visit '/'
    click_on 'add_task_button'
    expect(page).to have_selector(:css, '#add_task')
  end

  it 'タスク詳細画面への遷移' do
    visit '/'
    first(:css, 'table#task_table tbody tr').find_link('Rspec test 1').click
    expect(page).to have_selector(:css, '#show_task')
  end

  before { create(:task, title: 'Rspec test 1' ) }

  it 'タスク編集画面への遷移' do
    visit '/'
    first(:css, 'table#task_table tbody tr').find('td a.edit-button').click
    expect(page).to have_selector(:css, '#edit_task')
  end

end

describe 'タスクの削除処理', type: :feature do
  before { create(:task, title: 'Rspec test 1' ) }

  it '削除処理をキャンセルする' do
    visit '/'

    expect(page).to have_css('table#task_table tbody tr', count: 1)
    first(:css, 'table#task_table tbody tr').find('td a.trash-button').click
    page.dismiss_confirm

    expect(page).to have_css('table#task_table tbody tr', count: 1)
  end

  it '削除処理を実行する' do
    visit '/'

    expect(page).to have_css('table#task_table tbody tr', count: 1)
    first(:css, 'table#task_table tbody tr').find('td a.trash-button').click
    page.accept_confirm

    expect(page).to have_css('.alert-success')
    expect(page).to have_css('table#task_table tbody tr', :count=>0)
  end
end
