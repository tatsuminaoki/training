require 'rails_helper'
require 'selenium-webdriver'

RSpec.feature "Lists", type: :feature do
  before do
    # TODO: ユーザ認証が実装されていないため、user_id=1固定(修正必要)
    @user = FactoryBot.create(:user, id: 1)
    @task1 = FactoryBot.create(:task)
    @task2 = FactoryBot.create(:task)

    visit list_index_path
  end
  # TODO:labelはlocate.yml実装後変更が必要
  scenario "新しいタスクを作成する" do
    params = {
      task_name: "newtask1",
      description: "newdescription1"
    }
    expect {
      click_link "新規登録"
      fill_in "Task name", with: params[:task_name]
      fill_in "Description", with: params[:description]
      click_button "登録"
      expect(page).to have_content "タスクの登録が完了しました。"
      expect(page).to have_content params[:task_name]
      expect(page).to have_content params[:description]
    }.to change(@user.task, :count).by(1)
  end
  scenario "タスクを変更する" do
    params = {
      task_name: "updatetask1",
      description: "updatedescription1"
    }
    all(:link_or_button, "編集")[0].click
    fill_in "Task name", with: params[:task_name]
    fill_in "Description", with: params[:description]
    click_button "編集"
    expect(page).to have_content "タスクの変更が完了しました。"
    expect(page).to have_content params[:task_name]
    expect(page).to have_content params[:description]
    @task1.reload
    expect(@task1.task_name).to eq params[:task_name]
    expect(@task1.description).to eq params[:description]
  end
  scenario "タスクを削除" do
    # TODO: なぜかchrome-driverで実施するとconfirmダイアログが表示されないので余裕があれば確認
    all(:link_or_button, "削除")[0].click
    expect(page).to have_content "タスクの削除が完了しました。"
    expect(page).not_to have_content @task1.task_name
    expect(page).not_to have_content @task1.description
    expect { @task1.reload }.to raise_error(ActiveRecord::RecordNotFound)
  end
end
