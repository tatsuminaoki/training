# frozen_string_literal: true

require 'rails_helper'

describe 'ラベル一覧画面', type: :feature do
  let!(:user) { create(:user) }

  describe 'アクセス' do
    before do
      login(user: user)
      visit labels_path
    end

    context '非ログイン状態でアクセスした場合' do
      it 'ログイン画面が表示されること' do
        visit_without_login(visit_path: labels_path)
        expect(page).to have_css('.form-signin')
      end
    end

    context 'ログイン状態でアクセスした場合' do
      it 'ラベル一覧画面が表示されること' do
        expect(page).to have_css('#todo_app_label_list')
      end
    end
  end

  describe 'タスクの表示内容の検証' do
    let(:task) { create(:task) }
    let(:records) { all('#label_table tbody tr') }

    before do
      create(:task, label_list: 'label1, label3')
      create(:task, label_list: 'label2, label4')
      login(user: user)
      visit labels_path
    end

    it '登録されている全てのラベルが表示されること' do
      expect(records.size).to eq 4
    end

    it 'ラベル名でソートされていること' do
      records.each.with_index do |r, i|
        expect(r).to have_content("label#{i + 1}")
      end
    end
  end

  describe 'タスク一覧画面への遷移' do
    before do
      5.times { |i| create(:task, title: "task #{i}", user_id: user.id, label_list: 'label1') }
      4.times { |i| create(:task, title: "task #{i}", user_id: user.id, label_list: 'label2') }
      3.times { |i| create(:task, title: "task #{i}", user_id: user.id, label_list: 'label3') }

      login(user: user)
      visit labels_path
    end

    let(:record) { all('#label_table tbody tr').first }

    it 'タスク一覧画面に遷移できること' do
      record.find('a').click
      expect(page).to have_css('#todo_app_task_list')
    end

    it '選択したラベルに紐付くタスクのみ表示されていること' do
      record.find('a').click
      tasks = all('table#task_table tbody tr').map { |tr| tr.all('td')[1].find('a').text }
      expect(tasks).to match_array((0..4).map { |i| "task #{i}" })
    end
  end
end
