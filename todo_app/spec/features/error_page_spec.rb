# frozen_string_literal: true

require 'rails_helper'
require 'features/test_helpers'

shared_examples_for 'エラー画面の検証' do |status_code, description|
  before { visit_after_login(user: user, visit_path: path) }

  it "#{status_code.to_s}のエラー画面が表示されていること" do
    expect(page).to have_selector('.error-title', text: status_code.to_s)
    expect(page).to have_selector('.text-muted', text: description.to_s)
    expect(page).to have_link('HOME PAGE', href: '/')
  end
end

describe 'エラー画面', type: :feature do
  let(:user) { create(:user) }

  describe 'URLのエラー' do
    context '/404へアクセスした場合の画面表示' do
      let(:path) { '/404' }
      it_should_behave_like 'エラー画面の検証', 404, 'お探しのページは見つかりませんでした。'
    end

    context '存在しないパスへアクセスした場合の画面表示' do
      let(:path) { '/undefined' }
      it_should_behave_like 'エラー画面の検証', 404, 'お探しのページは見つかりませんでした。'
    end

    context '/422へアクセスした場合の画面表示' do
      let(:path) { '/422' }
      it_should_behave_like 'エラー画面の検証', 422, 'このページは表示できません。'
    end

    context '/500へアクセスした場合の画面表示' do
      let(:path) { '/500' }
      it_should_behave_like 'エラー画面の検証', 500, 'ページが表示できません。'
    end
  end

  describe '内部エラー' do
    let(:path) { root_path }
    before { allow(Task).to receive(:search).and_raise(error)}

    context 'StandardError' do
      let(:error) { StandardError }
      it_should_behave_like 'エラー画面の検証', 500, 'ページが表示できません。'
    end

    context 'ActionController::InvalidCrossOriginRequest' do
      let(:error) { ActiveRecord::RecordInvalid }
      it_should_behave_like 'エラー画面の検証', 422, 'このページは表示できません。'
    end

    context 'ActiveRecord::RecordInvalid' do
      let(:error) { ActiveRecord::RecordInvalid }
      it_should_behave_like 'エラー画面の検証', 422, 'このページは表示できません。'
    end
  end
end
