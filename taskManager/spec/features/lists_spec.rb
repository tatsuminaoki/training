require 'rails_helper'
require 'selenium-webdriver'

RSpec.feature "Lists", type: :feature do
  # TODO: ユーザ認証が実装されていないため、user_id=1固定(修正必要)
  let(:user) { FactoryBot.create(:user, id: 1) }
  let!(:task1) { FactoryBot.create(:task, user_id: user.id, created_at: "2018-05-21 15:00:00") }
  let!(:task2) { FactoryBot.create(:task, user_id: user.id, created_at: "2018-05-21 14:00:00") }

  scenario "新しいタスクを作成する" do
    params = {
      task_name: "newtask1",
      description: "newdescription1"
    }
    visit list_index_path
    expect {
      click_link "新規登録"
      fill_in "task[task_name]", with: params[:task_name]
      fill_in "task[description]", with: params[:description]
      click_button "登録"
      expect(page).to have_content "タスクの新規登録が成功しました。"
      expect(page).to have_content params[:task_name]
      expect(page).to have_content params[:description]
    }.to change(user.task, :count).by(1)
  end
  scenario "タスクを変更する" do
    params = {
      task_name: "updatetask1",
      description: "updatedescription1"
    }
    visit list_index_path
    all(:link_or_button, "編集")[0].click
    fill_in "task[task_name]", with: params[:task_name]
    fill_in "task[description]", with: params[:description]
    click_button "編集"
    expect(page).to have_content "タスクの編集が成功しました。"
    expect(page).to have_content params[:task_name]
    expect(page).to have_content params[:description]
    task1.reload
    expect(task1.task_name).to eq params[:task_name]
    expect(task1.description).to eq params[:description]
  end
  scenario "タスクを削除" do
    visit list_index_path
    # TODO: なぜかchrome-driverで実施するとconfirmダイアログが表示されないので余裕があれば確認
    all(:link_or_button, "削除")[0].click
    expect(page).to have_content "タスクの削除が成功しました。"
    expect(page).not_to have_content task1.task_name
    expect(page).not_to have_content task1.description
    expect { task1.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
  scenario "タスクの並び順の確認(STEP10 登録日時の降順)" do
    task3 = FactoryBot.create(:task, user_id: user.id, created_at: "2018-05-19 15:00:00")
    task4 = FactoryBot.create(:task, user_id: user.id, created_at: "2018-05-30 14:00:00")
    visit list_index_path

    # order: 登録日(降順) task4 -> task1 -> task2 -> task3
    expect(Task.all).to eq [task4, task1, task2, task3]
  end
  scenario "タスクの並び順の確認(STEP12 期限の昇順 + 登録日時の降順)" do
    task3 = FactoryBot.create(:task, user_id: user.id, deadline: "2018-05-19 15:00:00", created_at: "2018-05-19 15:00:00")
    task4 = FactoryBot.create(:task, user_id: user.id, deadline: nil, created_at: "2018-05-20 15:00:00")
    task5 = FactoryBot.create(:task, user_id: user.id, deadline: "2018-05-30 14:00:00", created_at: "2018-05-22 15:00:00")
    visit list_index_path

    # order: 登録日(降順) task4 -> task1 -> task2 -> task3
    expect(Task.all).to eq [task3, task5, task1, task2, task4]
  end
end
