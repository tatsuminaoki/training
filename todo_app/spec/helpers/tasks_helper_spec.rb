require 'rails_helper'

RSpec.describe TasksHelper, type: :helper do
  describe 'プルダウンのリスト確認' do
    context 'ステータスの場合' do
      it '3件であること' do
        expect(status_pull_down.size).to eq 3
      end

      it '未着手 / 進行中 / 完了が存在すること' do
        expected = [%w(未着手 not_start), %w(進行中 progress), %w(完了 done)]
        expect(status_pull_down).to eq expected
      end
    end

    context '優先度の場合' do
      it '5件であること' do
        expect(priority_pull_down.size).to eq 5
      end

      it '低い / 通常 / 高い / 急いで / 今すぐが存在すること' do
        expected = [%w(低い low), %w(通常 normal), %w(高い high), %w(急いで quickly), %w(今すぐ right_now)]
        expect(priority_pull_down).to eq expected
      end
    end
  end

  describe '名称の取得' do
    context 'ステータス表示名のパターンテスト' do
      it '未着手が返却されること' do
        expect(status_value('not_start')).to eq Task.human_attribute_name('statuses.not_start')
      end

      it '進行中が返却されること' do
        expect(status_value('progress')).to eq Task.human_attribute_name('statuses.progress')
      end

      it '完了が返却されること' do
        expect(status_value('done')).to eq Task.human_attribute_name('statuses.done')
      end
    end

    context '優先順位表示名のパターンテスト' do
      it '低いが返却されること' do
        expect(priority_value('low')).to eq Task.human_attribute_name('priorities.low')
      end

      it '通常が返却されること' do
        expect(priority_value('normal')).to eq Task.human_attribute_name('priorities.normal')
      end

      it '高いが返却されること' do
        expect(priority_value('high')).to eq Task.human_attribute_name('priorities.high')
      end

      it '急いでが返却されること' do
        expect(priority_value('quickly')).to eq Task.human_attribute_name('priorities.quickly')
      end

      it '今すぐが返却されること' do
        expect(priority_value('right_now')).to eq Task.human_attribute_name('priorities.right_now')
      end
    end
  end
end
