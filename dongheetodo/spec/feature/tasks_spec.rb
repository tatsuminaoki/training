require "rails_helper"
require "i18n"
require "faker"

RSpec.feature "Tasks", type: :feature, js: true do
  given(:email) { Faker::Internet.email }
  given(:password) { Faker::Internet.password(min_length: 8) }
  given!(:user) { create(:user, email: email, password: password) }
  given!(:task1) { create(:task, user_id: user.id) }
  given!(:task2) { create(:task, user_id: user.id) }
  given!(:task3) { create(:task, user_id: user.id) }
  given!(:task4) { create(:task, user_id: user.id) }
  given!(:task5) { create(:task, user_id: user.id) }
  given!(:label1) { create(:label, name: 'label1') }
  given!(:label2) { create(:label, name: 'label2') }
  given!(:label3) { create(:label, name: 'label3') }
  given!(:label4) { create(:label, name: 'label4') }
  given!(:label5) { create(:label, name: 'label5') }
  given!(:task_label1) { create(:task_label, task: task1, label: label1) }
  given!(:task_label2) { create(:task_label, task: task1, label: label3) }
  given!(:task_label3) { create(:task_label, task: task1, label: label4) }
  given!(:task_label4) { create(:task_label, task: task3, label: label1) }
  given!(:task_label5) { create(:task_label, task: task1, label: label5) }

  ### CRUDテスト

  scenario "タスク一覧を表示する", open_on_error: true do
    login_as(user)
    expect(page).to have_content I18n.t("activerecord.tasks.index.title")
  end

  scenario "ログインしないとタスク一覧が表示されない", open_on_error: true do
    visit tasks_path
    expect(page).not_to have_content I18n.t("activerecord.tasks.index.title")
  end

  scenario "タスクを作成する", open_on_error: true do
    login_as(user)
    click_link I18n.t("button.create")
    fill_in "task_name", with: "ダミーデータ"
    fill_in "task_description", with: "ダミー内容"
    select I18n.t("activerecord.enum.task.status.doing"), from: "task_status"
    select I18n.t("activerecord.enum.task.priority.mid"), from: "task_priority"
    check "label_#{label1.id}"
    check "label_#{label5.id}"
    find("input[type=submit]").click
    expect(page).to have_content I18n.t("message.success.complete_create")
    expect(page).to have_content label1.name
    expect(page).to have_content label5.name
  end

  scenario "タスク詳細を表示する", open_on_error: true do
    login_as(user)
    all("tbody tr")[0].all("td")[1].find("a").click
    expect(page).to have_text I18n.t("activerecord.tasks.show.title")
  end

  scenario "タスクを更新する", open_on_error: true do
    login_as(user)
    create(:task_label, task: task5, label: label2)
    create(:task_label, task: task5, label: label4)

    all("tbody tr")[0].find("a", text: I18n.t("button.edit")).click
    fill_in "task_description", with: Faker::Lorem.characters(255)
    select I18n.t("activerecord.enum.task.status.doing"), from: "task_status"
    select I18n.t("activerecord.enum.task.priority.mid"), from: "task_priority"
    uncheck "label_#{label2.id}"
    uncheck "label_#{label4.id}"
    check "label_#{label1.id}"
    check "label_#{label5.id}"
    check "label_#{label3.id}"
    find("input[type=submit]").click
    expect(page).to have_content I18n.t("message.success.complete_update")
    expect(page).to have_text label1.name
    expect(page).to have_text label3.name
    expect(page).to have_text label5.name
  end

  scenario "タスクを削除する", open_on_error: true do
    login_as(user)
    all("tbody tr")[0].find("a", text: I18n.t("button.delete")).click
    accept_alert I18n.t('alert.task.delete')
    expect(page).to have_content I18n.t('message.success.complete_delete')
  end

  ### 検索テスト

  scenario "タスク名で絞り込んで検索する", open_on_error: true do
    login_as(user)
    within("#search_form") do
      fill_in "name", with: task1.name
      click_button I18n.t("button.search")
    end
    expect(find("tbody")).to have_text task1.id
  end

  scenario "ステータスで絞り込んで検索する", open_on_error: true do
    login_as(user)
    within("#search_form") do
      select I18n.t("activerecord.enum.task.status.#{task1.status}"), from: "status"
      click_button I18n.t("button.search")
    end
    expect(find("tbody")).to have_text task1.id
  end

  scenario "タスク名とステータスで絞り込んで検索する", open_on_error: true do
    login_as(user)
    within("#search_form") do
      fill_in "name", with: task1.name
      select I18n.t("activerecord.enum.task.status.#{task1.status}"), from: "status"
      click_button I18n.t("button.search")
    end
    expect(find("tbody")).to have_text task1.id
  end

  ### 並び替えテスト

  scenario "IDで並び順を変える", open_on_error: true do
    login_as(user)
    # 降順にする
    within("#search_form") do
      select I18n.t("label.task.id"), from: "target"
      select I18n.t("label.sort.desc"), from: "order"
      click_button I18n.t("button.search")
    end
    first_id = all("tbody tr")[0].all("td")[0].text
    last_id = all("tbody tr")[8].all("td")[0].text
    expect(first_id).to be > last_id
    # 昇順にする
    within("#search_form") do
      select I18n.t("label.task.id"), from: "target"
      select I18n.t("label.sort.asc"), from: "order"
      click_button I18n.t("button.search")
    end
    first_id = all("tbody tr")[0].all("td")[0].text
    last_id = all("tbody tr")[8].all("td")[0].text
    expect(first_id).to be < last_id
  end

  scenario "完了期限で並び順を変える", open_on_error: true do
    login_as(user)
    # 降順にする
    within("#search_form") do
      select I18n.t("label.task.duedate"), from: "target"
      select I18n.t("label.sort.desc"), from: "order"
      click_button I18n.t("button.search")
    end
    first_duedate = all("tbody tr")[0].all("td")[4].text
    last_duedate = all("tbody tr")[8].all("td")[4].text
    expect(first_duedate).to be > last_duedate
    # 昇順にする
    within("#search_form") do
      select I18n.t("label.task.duedate"), from: "target"
      select I18n.t("label.sort.asc"), from: "order"
      click_button I18n.t("button.search")
    end
    first_duedate = all("tbody tr")[0].all("td")[4].text
    last_duedate = all("tbody tr")[8].all("td")[4].text
    expect(first_duedate).to be < last_duedate
  end

  scenario "作成日で並び順を変える", open_on_error: true do
    login_as(user)
    # 降順にする
    within("#search_form") do
      select I18n.t("label.task.created_at"), from: "target"
      select I18n.t("label.sort.desc"), from: "order"
      click_button I18n.t("button.search")
    end
    first_created_at = all("tbody tr")[0].all("td")[5].text
    last_created_at = all("tbody tr")[8].all("td")[5].text
    expect(first_created_at).to be > last_created_at

    # 昇順にする
    within("#search_form") do
      select I18n.t("label.task.created_at"), from: "target"
      select I18n.t("label.sort.asc"), from: "order"
      click_button I18n.t("button.search")
    end
    first_created_at = all("tbody tr")[0].all("td")[5].text
    last_created_at = all("tbody tr")[8].all("td")[5].text
    expect(first_created_at).to be < last_created_at
  end

  scenario "タスク一覧にページナビゲーターを表示する", open_on_error: true do
    # 最初はページナビゲーターが表示されない
    login_as(user)
    expect(page).not_to have_selector "ul.pagination"
    # Taskを20件生成してページナビゲーターを出す
    20.times do
      create(:task, user_id: user.id)
    end
    visit tasks_path
    expect(page).to have_selector "ul.pagination"
  end

  scenario "他のページに遷移する" do
    login_as(user)
    20.times do
      create(:task, user_id: user.id)
    end
    visit tasks_path
    click_link "最後 »"
    expect(page).to have_link "« 最初"
  end
end
