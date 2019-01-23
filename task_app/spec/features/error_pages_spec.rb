# frozen_string_literal: true

require 'rails_helper'

feature 'エラー画面の表示機能', type: :feature do
  feature 'getリクエスト' do
    shared_examples_for 'エラー画面が表示される(getリクエスト)' do |path, http_status, content|
      before { visit path }
      it { expect(page).to have_content "#{http_status}:#{content}" }
    end

    context '/404にアクセスしたとき' do
      it_should_behave_like 'エラー画面が表示される(getリクエスト)', '/404', 404, 'お探しのページは見つかりませんでした'
    end

    context '/hogeにアクセスしたとき' do
      it_should_behave_like 'エラー画面が表示される(getリクエスト)', '/hoge', 404, 'お探しのページは見つかりませんでした'
    end

    context '/422にアクセスしたとき' do
      it_should_behave_like 'エラー画面が表示される(getリクエスト)', '/422', 422, 'このページは表示できません'
    end

    context '/500にアクセスしたとき' do
      it_should_behave_like 'エラー画面が表示される(getリクエスト)', '/500', 500, '一時的なエラーが発生しました'
    end
  end

  feature '内部エラー' do
    before do
      allow(Task).to receive(:all).and_raise(error)
      visit root_path
    end

    shared_examples_for 'エラー画面が表示される(内部エラー)' do |http_status, content|
      it { expect(page).to have_content "#{http_status}:#{content}" }
    end

    context 'ActiveRecord::RecordInvalidを発生させたとき(422)' do
      let(:error) { ActiveRecord::RecordInvalid }
      it_should_behave_like 'エラー画面が表示される(内部エラー)', 422, 'このページは表示できません'
    end

    context 'ActiveRecord::RecordNotUniqueを発生させたとき(422)' do
      let(:error) { ActiveRecord::RecordNotUnique }
      it_should_behave_like 'エラー画面が表示される(内部エラー)', 422, 'このページは表示できません'
    end

    context 'StandardErrorを発生させたとき(500)' do
      let(:error) { StandardError }
      it_should_behave_like 'エラー画面が表示される(内部エラー)', 500, '一時的なエラーが発生しました'
    end
  end
end
