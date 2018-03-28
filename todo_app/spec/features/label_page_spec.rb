# frozen_string_literal: true

require 'rails_helper'

describe 'ラベル一覧画面', type: :feature do
  let!(:user) { create(:user) }

  describe 'アクセス' do
    before { visit_after_login(user: user, visit_path: labels_path) }

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

  describe 'ラベルの表示内容の検証' do
    let!(:tasks) { create_list(:task_with_label, 3) }
    let(:records) { all('#label_table tbody tr') }

    before { visit_after_login(user: user, visit_path: labels_path) }

    it '登録されている全てのラベルが表示されること' do
      expect(records.size).to eq 3
    end

    it 'ラベル名でソートされていること' do
      expected_tasks = ActsAsTaggableOn::Tag.order(:name).pluck(:name)
      actual_tasks = all('table#label_table tbody tr').map { |tr| tr.all('td')[0].find('a').text }
      expect(expected_tasks).to match actual_tasks
    end
  end

  describe '表示件数の検証' do
    let(:user) { create(:user) }
    let!(:tasks) { create_list(:task_with_label, 15, user_id: user.id) }
    let(:records) { all('#label_table tbody tr') }

    before { visit_after_login(user: user, visit_path: labels_path) }

    it '最大は10件表示されること' do
      expect(records.size).to eq 10
    end

    it 'ページをクリックすると次の最大10件が取得できること' do
      first('.page-item a[rel="next"]').click
      expect(records.size).to eq 5
    end
  end

  describe 'タスク一覧画面への遷移' do
    let!(:label1_group) { create_list(:task_with_label, 2, label_list: 'label1', user_id: user.id) }
    let!(:label2_group) { create_list(:task_with_label, 2, label_list: 'label2', user_id: user.id) }
    let(:record) { all('#label_table tbody tr').first }

    before { visit_after_login(user: user, visit_path: labels_path) }

    it 'タスク一覧画面に遷移できること' do
      record.find('a').click
      expect(page).to have_css('#todo_app_task_list')
    end

    it '選択したラベルに紐付くタスクのみ表示されていること' do
      label = ActsAsTaggableOn::Tag.order(:name).limit(1).first.name
      expected_tasks = Task.tagged_with(label).map(&:title)

      record.find('a').click
      actual_tasks = all('table#task_table tbody tr').map { |tr| tr.all('td')[1].find('a').text }
      expect(expected_tasks).to match_array(actual_tasks)
    end
  end
end
