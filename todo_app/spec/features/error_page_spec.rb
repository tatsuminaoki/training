# frozen_string_literal: true

require 'rails_helper'
require 'features/test_helpers'

shared_examples_for 'エラー画面の検証' do |status_code, description|
  it 'エラー画面が表示されていることを' do
    expect(page).to have_selector('.error-title', text: status_code.to_s)
    expect(page).to have_selector('.text-muted', text: description.to_s)
    expect(page).to have_link('HOME PAGE', href: '/')
  end
end

describe 'エラー画面', type: :feature do
  let(:user) { create(:user) }

  describe 'URLのエラー' do
    before { visit_after_login(user: user, visit_path: path) }

    context '/404へアクセスした場合' do
      let(:path) { '/404' }

      it '404エラー画面へ遷移すること' do
        expect(page).to have_selector('.error-title', text: '4O4')
        expect(page).to have_selector('.text-muted', text: 'お探しのページは見つかりませんでした。')
        expect(page).to have_link('HOME PAGE', href: '/')
      end
    end

    context '存在しないパスへアクセスした場合' do
      let(:path) { '/undefined' }

      it '404エラー画面へ遷移すること' do
        expect(page).to have_selector('.error-title', text: '4O4')
        expect(page).to have_selector('.text-muted', text: 'お探しのページは見つかりませんでした。')
        expect(page).to have_link('HOME PAGE', href: '/')
      end
    end

    context '/422へアクセスした場合' do
      let(:path) { '/422' }

      it '422エラー画面へ遷移すること' do
        expect(page).to have_selector('.error-title', text: '422')
        expect(page).to have_selector('.text-muted', text: 'このページは表示できません。')
        expect(page).to have_link('HOME PAGE', href: '/')
      end
    end

    context '/500へアクセスした場合' do
      let(:path) { '/500' }

      it '500エラー画面へ遷移すること' do
        expect(page).to have_selector('.error-title', text: '500')
        expect(page).to have_selector('.text-muted', text: 'ページが表示できません。')
        expect(page).to have_link('HOME PAGE', href: '/')
      end
    end
  end

  describe '内部エラーの検証' do
    let(:path) { root_path }
    before { allow(Task).to receive(:search).and_raise(error)}
    before { visit_after_login(user: user, visit_path: tasks_path) }

    context 'StandardError' do
      let(:error) { StandardError }
      it_should_behave_like 'エラー画面の検証', 500, 'ページが表示できません。'
    end
  end
end
