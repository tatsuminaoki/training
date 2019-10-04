require 'rails_helper'
require 'i18n'

RSpec.feature "Tasks", type: :feature, js: true do

  given!(:user) { create(:user) }
  given!(:task1) { create(:task, user_id: user.id) }
  given!(:task2) { create(:task, user_id: user.id) }
  given!(:task3) { create(:task, user_id: user.id) }
  given!(:task4) { create(:task, user_id: user.id) }
  given!(:task5) { create(:task, user_id: user.id) }

  ### CRUDテスト

  scenario "タスク一覧を表示する", open_on_error: true do
    visit tasks_path
    expect(page).to have_content "タスク一覧"
  end

  scenario "タスクを作成する", open_on_error: true do
    visit new_task_path
    fill_in "task_name", with: "ダミーデータ"
    fill_in "task_description", with: "ダミー内容"
    select "完了", from: "task_status"
    select "中", from: "task_priority"
    click_button "登録する"
    expect(page).to have_content "正常に作成しました"
  end

  scenario "タスク詳細を表示する", open_on_error: true do
    visit root_path
    all("tbody tr ")[0].click_link "詳細"
    expect(page).to have_content "タスク詳細"
  end

  scenario "タスクを更新する", open_on_error: true do
    visit root_path
    all("tbody tr ")[0].click_link "修正"
    fill_in "task_name", with: "更新するよー"
    fill_in "task_description", with: "テストのため更新します"
    select "未着手", from: "task_status"
    select "低", from: "task_priority"
    click_button "更新する"
    expect(page).to have_content "正常に更新しました"
  end

  scenario "タスクを削除する", open_on_error: true do
    visit tasks_path
    all("tbody tr ")[0].click_link "削除"
    accept_alert "本当に削除しますか？"
    expect(page).to have_content "正常に削除しました"
  end

  ### 検索テスト

  scenario 'タスク名で絞り込んで検索する', open_on_error: true do
    visit tasks_path
    within('#search_form') do
      fill_in 'name', with: task1.name
      click_button I18n.t('button.search')
    end
    expect(find('tbody')).to have_text task1.id
  end

  scenario 'ステータスで絞り込んで検索する', open_on_error: true do
    visit tasks_path
    within('#search_form') do
      select I18n.t("activerecord.enum.task.status.#{task1.status}"), from: 'status'
      click_button I18n.t('button.search')
    end
    expect(find('tbody')).to have_text task1.id
  end

  scenario 'タスク名とステータスで絞り込んで検索する', open_on_error: true do
    visit tasks_path
    within('#search_form') do
      fill_in 'name', with: task1.name
      select I18n.t("activerecord.enum.task.status.#{task1.status}"), from: 'status'
      click_button I18n.t('button.search')
    end
    expect(find('tbody')).to have_text task1.id
  end

  ### 並び替えテスト

  scenario "IDで並び順を変える", open_on_error: true do
    visit tasks_path
    # 降順にする
    within('#search_form') do
      select I18n.t('label.task.id'), from: 'target'
      select I18n.t('label.sort.desc'), from: 'order'
      click_button I18n.t('button.search')
    end
    first_id = all('tbody tr').first.all('td')[0].text
    last_id = all('tbody tr').last.all('td')[0].text
    expect(first_id).to be > last_id
    # 昇順にする
    within('#search_form') do
      select I18n.t('label.task.id'), from: 'target'
      select I18n.t('label.sort.asc'), from: 'order'
      click_button I18n.t('button.search')
    end
    first_id = all('tbody tr').first.all('td')[0].text
    last_id = all('tbody tr').last.all('td')[0].text
    expect(first_id).to be < last_id
  end

  scenario "完了期限で並び順を変える", open_on_error: true do
    visit tasks_path
    # 降順にする
    within('#search_form') do
      select I18n.t('label.task.duedate'), from: 'target'
      select I18n.t('label.sort.desc'), from: 'order'
      click_button I18n.t('button.search')
    end
    first_duedate = all('tbody tr').first.all('td')[4].text
    last_duedate = all('tbody tr').last.all('td')[4].text
    expect(first_duedate).to be > last_duedate
    # 昇順にする
    within('#search_form') do
      select I18n.t('label.task.duedate'), from: 'target'
      select I18n.t('label.sort.asc'), from: 'order'
      click_button I18n.t('button.search')
    end
    first_duedate = all('tbody tr').first.all('td')[4].text
    last_duedate = all('tbody tr').last.all('td')[4].text
    expect(first_duedate).to be < last_duedate
  end

  scenario "作成日で並び順を変える", open_on_error: true do
    visit tasks_path
    # 降順にする
    within('#search_form') do
      select I18n.t('label.task.created_at'), from: 'target'
      select I18n.t('label.sort.desc'), from: 'order'
      click_button I18n.t('button.search')
    end
    first_created_at = all('tbody tr').first.all('td')[5].text
    last_created_at = all('tbody tr').last.all('td')[5].text
    expect(first_created_at).to be > last_created_at

    # 昇順にする
    within('#search_form') do
      select I18n.t('label.task.created_at'), from: 'target'
      select I18n.t('label.sort.asc'), from: 'order'
      click_button I18n.t('button.search')
    end
    first_created_at = all('tbody tr').first.all('td')[5].text
    last_created_at = all('tbody tr').last.all('td')[5].text
    expect(first_created_at).to be < last_created_at
  end

  scenario "タスク一覧にページナビゲーターを表示する" do
    # 最初はページナビゲーターが表示されない
    visit tasks_path
    expect(page).not_to have_selector 'nav.pagination'
    # Taskを20件生成してページナビゲーターを出す
    20.times do
      create(:task, user_id: user.id)
    end
    visit tasks_path
    expect(page).to have_selector 'nav.pagination'
  end

  scenario "他のページに遷移する" do
    20.times do
      create(:task, user_id: user.id)
    end
    visit tasks_path
    click_link '最後 »'
    expect(page).to have_link '« 最初'
  end
end
