require 'rails_helper'
require 'selenium-webdriver'

RSpec.feature "Lists", type: :feature do
  let(:user) { FactoryBot.create(:user) }
  let!(:task) { FactoryBot.create_list(:task, 9, user: user) }
  let!(:expect_result) {
    task.sort do |a, b|
      b[:created_at] <=> a[:created_at]
    end
  }

  before do
    visit login_index_path
    fill_in "user[mail]", with: user.mail
    fill_in "user[password]", with: user.password
    click_button "ログイン"
  end

  feature "タスクの追加" do
    let(:params) do
      {
        task_name: "newtask1",
        description: "newdescription1"
      }
    end
    scenario "新しいタスクを作成する" do
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
    let(:params) do {
      task_name: "updatetask1",
      description: "updatedescription1"
    }
    end
    scenario "タスクを変更できる" do
      all(:link_or_button, "編集")[0].click
      fill_in "task[task_name]", with: params[:task_name]
      fill_in "task[description]", with: params[:description]
      click_button "編集"
      expect(page).to have_content "タスクの編集が成功しました。"
      expect(page).to have_content params[:task_name]
      expect(page).to have_content params[:description]

      expect_result[0].reload
      expect(expect_result[0].task_name).to eq params[:task_name]
      expect(expect_result[0].description).to eq params[:description]
    end
  end
  feature "タスクを削除" do
    scenario "タスクを削除できること" do
      # TODO: なぜかchrome-driverで実施するとconfirmダイアログが表示されないので余裕があれば確認
      all(:link_or_button, "削除")[0].click
      expect(page).to have_content "タスクの削除が成功しました。"
      expect(page).not_to have_content expect_result[0].task_name
      expect(page).not_to have_content expect_result[0].description
      expect { expect_result[0].reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
  feature "タスクの並びテスト" do
    let!(:expect_str) { expect_result.map {|h| h[:task_name]}.join('.*') }
    scenario "タスクの並び順の確認(STEP10 登録日時の降順)" do
      expect(page.text.inspect).to match %r(#{expect_str})
    end
  end
  feature "タスクの並び順(期限の昇順)" do
    let!(:sort_result) {
      expect_result.sort do |a, b|
        a[:deadline] <=> b[:deadline]
      end
    }
    let(:expect_asc_str) { sort_result.map {|h| h[:task_name]}.join('.*') }
    let(:expect_desc_str) { sort_result.reverse.map {|h| h[:task_name]}.join('.*') }
    scenario "タスクの並び順の確認(STEP12 期限の昇順)" do
      # order: 登録日(降順) task4 -> task3 -> task5
      find("//*[@class='th_deadline']//a[text()='期限']").click
      expect(page.text.inspect).to match %r(#{expect_asc_str})
    end
    scenario "タスクの並び順の確認(STEP12 期限の降順)" do
      # order: 登録日(降順) task5 -> task3 -> task4
      find("//*[@class='th_deadline']//a[text()='期限']").click # 昇順
      find("//*[@class='th_deadline']//a[text()='期限']").click # 降順
      expect(page.text.inspect).to match %r(#{expect_desc_str})
    end
  end
  feature "ステータスで検索" do
    let(:expect_result) {
      task.select{ |i| i[:status] == "completed" }.sort do |a, b|
        a[:created_at] <=> b[:created_at]
      end
    }
    let(:expect_str) { expect_result.reverse.map {|h| h[:task_name]}.join('.*') }
    scenario "ステータスで検索ができる" do
      select '完了', from: 'status'
      click_button "検索"

      # order: 登録日(降順)
      expect(page.text.inspect).to match %r(#{expect_str})
    end
  end
  feature "タスク名検索" do
    let!(:task2) { FactoryBot.create(:task, user_id: user.id, status: :completed, task_name: "タスク2") }
    let!(:task3) { FactoryBot.create(:task, user_id: user.id, status: :waiting, task_name: "タスク3") }
    let!(:expect_result) {
      task.select{ |i| i[:task_name] =~ /タスク/ }.sort do |a, b|
        a[:created_at] <=> b[:created_at]
      end
    }
    let(:expect_str) { expect_result.reverse.map {|h| h[:task_name]}.join('.*') }
    scenario "タスク名で検索ができる" do
      fill_in "task_name", with: "タスク"
      click_button "検索"
      expect(page.text.inspect).to match %r(#{expect_str})
    end
  end
  feature "ページングのテスト" do
    scenario "10件以下" do
      expect(page).not_to have_selector(".pagination")
    end
    scenario "10件の場合、ページングが無い" do
      FactoryBot.create(:task, user: user)
      visit list_index_path
      expect(Task.all.size).to eq(10)
      expect(page).not_to have_selector(".pagination")
    end
    scenario "11件の場合、ページングでページ遷移ができる" do
      9.times{ FactoryBot.create(:task, user: user) }
      expect(Task.all.size).to eq(18)
      visit list_index_path
      find("//*[@class='pagination']//a[text()='2']").click
      expect(page.status_code).to eq(200)
      find("//*[@class='pagination']//a[text()='1']").click
      expect(page.status_code).to eq(200)
    end
  end
end
