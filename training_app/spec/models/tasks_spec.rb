# frozen_string_literal: true

require 'rails_helper'

describe Task do
  describe '検索機能について' do
    let!(:task1) { Task.create(title: 'A', body: 'Hoge', status: :todo) }
    let!(:task2) { Task.create(title: 'B', body: 'Foo', status: :progress) }
    let!(:task3) { Task.create(title: 'C', body: 'Bar', status: :done) }

    it '検索を行うことができる' do
      params = { body_cont: 'O' }
      expect(Task.search(params).result.count).to eq(2)

      params = { status_eq: 2 }
      expect(Task.search(params).result.count).to eq(1)
    end
  end
end
