# frozen_string_literal: true

require 'rails_helper'

describe Task do
  describe '検索機能について' do
    let!(:task1) { create(:task, body: 'Hoge') }
    let!(:task2) { create(:task, body: 'Foo') }
    let!(:task3) { create(:task, body: 'Bar', status: :done) }

    it '検索を行うことができる' do
      params = { body_cont: 'o' }
      expect(Task.search(params).result.count).to eq(2)

      params = { status_eq: 2 }
      expect(Task.search(params).result.count).to eq(1)
    end
  end

  describe '多言語化ステータス名' do
    let!(:task1) { create(:task, status: :todo) }
    let!(:task2) { create(:task, status: :progress) }
    let!(:task3) { create(:task, status: :done) }

    it '多言語化されたステータス名を取得できる' do
      status_names = [task1, task2, task3].map(&:status_name)
      statuses = Hash[
        %i[todo progress done].map do |sym|
          [I18n.t("activerecord.enums.task.status.#{sym}"), Task.status_name(sym)]
        end
      ]

      expect(statuses.keys).to eq(statuses.values)
      expect(status_names).to eq(statuses.keys)
    end
  end
end
