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
end
