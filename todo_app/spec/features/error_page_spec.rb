# frozen_string_literal: true

require 'rails_helper'
require 'features/test_helpers'

describe 'エラー画面', type: :feature do
  before { visit path }

  context '/404へアクセスした場合' do
    let(:path) { '/404' }

    it '404エラー画面へ遷移すること' do
      expect(page).to have_selector('.error-title', text: '4O4')
      expect(page).to have_selector('.text-muted', text: 'Sorry, this page isn\'t available.')
      expect(page).to have_link('HOME PAGE', href: '/')
    end
  end

  context '存在しないパスへアクセスした場合' do
    let(:path) { '/undefined' }

    it '404エラー画面へ遷移すること' do
      expect(page).to have_selector('.error-title', text: '4O4')
      expect(page).to have_selector('.text-muted', text: 'Sorry, this page isn\'t available.')
      expect(page).to have_link('HOME PAGE', href: '/')
    end
  end

  context '/404へアクセスした場合' do
    let(:path) { '/422' }

    it '404エラー画面へ遷移すること' do
      expect(page).to have_selector('.error-title', text: '422')
      expect(page).to have_selector('.text-muted', text: 'The change you wanted was rejected.')
      expect(page).to have_link('HOME PAGE', href: '/')
    end
  end

  context '/500へアクセスした場合' do
    let(:path) { '/500' }

    it '404エラー画面へ遷移すること' do
      expect(page).to have_selector('.error-title', text: '500')
      expect(page).to have_selector('.text-muted', text: 'Sorry, but something went wrong.')
      expect(page).to have_link('HOME PAGE', href: '/')
    end
  end
end
