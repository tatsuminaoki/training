require 'rails_helper'
require 'selenium-webdriver'

RSpec.feature "Lists", type: :feature do
  # TODO: ユーザ認証が実装されていないため、user_id=1固定(修正必要)
  let(:user) { FactoryBot.create(:user, id: 1) }
  let!(:task1) { FactoryBot.create(:task, user_id: user.id, created_at: "2018-05-21 15:00:00") }
  let!(:task2) { FactoryBot.create(:task, user_id: user.id, created_at: "2018-05-21 14:00:00") }

  feature "タスクの追加" do
    let(:params) do
      {
        task_name: "newtask1",
        description: "newdescription1"
      }
    end
    scenario "新しいタスクを作成する" do
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
  end
  feature "タスク変更" do
    let(:params) do
      {
        task_name: "updatetask1",
        description: "updatedescription1"
      }
    end
    scenario "タスクを変更できる" do
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
  end
  feature "タスクを削除" do
    scenario "タスクを削除できること" do
      visit list_index_path
      # TODO: なぜかchrome-driverで実施するとconfirmダイアログが表示されないので余裕があれば確認
      all(:link_or_button, "削除")[0].click
      expect(page).to have_content "タスクの削除が成功しました。"
      expect(page).not_to have_content task1.task_name
      expect(page).not_to have_content task1.description
      expect { task1.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
  feature "タスクの並びテスト" do
    let!(:task3) { FactoryBot.create(:task, user_id: user.id, created_at: "2018-05-19 15:00:00") }
    let!(:task4) { FactoryBot.create(:task, user_id: user.id, created_at: "2018-05-30 14:00:00") }
    scenario "タスクの並び順の確認(STEP10 登録日時の降順)" do
      visit list_index_path

      ## ここの評価の仕方妥当では無いのですが、12、13くらいで修正加えてます。
      # order: 登録日(降順) task4 -> task1 -> task2 -> task3
      expect(page.text.inspect).to match %r(#{task4.task_name}.*#{task1.task_name}.*#{task2.task_name}.*#{task3.task_name})
    end
  end
  feature "ページングのテスト" do
    scenario "10件以下" do
      visit list_index_path
      expect(page).not_to have_selector(".pagination")
    end
    scenario "10件の場合、ページングが無い" do
      8.times{ FactoryBot.create(:task) }
      visit list_index_path
      expect(Task.all.size).to eq(10)
      expect(page).not_to have_selector(".pagination")
    end
    scenario "11件の場合、ページングでページ遷移ができる" do
      9.times{ FactoryBot.create(:task) }
      expect(Task.all.size).to eq(11)
      visit list_index_path
      find("//*[@class='pagination']//a[text()='2']").click
      expect(page.status_code).to eq(200)
      find("//*[@class='pagination']//a[text()='1']").click
      expect(page.status_code).to eq(200)
    end
  end
end
