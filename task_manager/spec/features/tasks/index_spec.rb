# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'tasks#index', type: :feature do
  given!(:user) { @user ||= create(:user) }
  given!(:task) { create(:task, user: user, tag_list: [nil]) }
  given!(:task_tag_AA)      { create(:task, user: user, tag_list: ['AA']) }
  given!(:task_tag_AA_AAAA) { create(:task, user: user, tag_list: %w[AA AAAA]) }
  given!(:task_tag_AABB)    { create(:task, user: user, tag_list: ['AABB']) }
  given!(:task_tag_BB)      { create(:task, user: user, tag_list: ['BB']) }

  before do
    visit login_path
    fill_in 'session_name', with: user.name
    fill_in 'session_password', with: user.password
    click_button 'Log in'
    fill_in 'タグ', with: search_words
    click_button '検索'
  end

  context 'search tag name with nil' do
    given(:search_words) { '' }

    scenario 'listed all tasks' do
      expect(page.all('tbody tr').size).to eq 5
    end
  end

  context 'search tag name with "AA"' do
    given(:search_words) { 'AA' }

    scenario 'listed tagged "AA" or "AABB" tasks' do
      expect(page.all('table tbody tr').size).to eq 3
      # 'AAAA' を２つに数えないように ' AA' で確認
      expect(page).to have_content(' AA', count: 4)
      expect(page).to have_content('AABB', count: 1)
    end
  end

  context 'search tag name with "B"' do
    given(:search_words) { 'BB' }

    scenario 'listed tagged "BB" or "AABB" tasks' do
      expect(page.all('table tbody tr').size).to eq 2
      expect(page).to have_content('BB', count: 2)
      expect(page).to have_content('AABB', count: 1)
    end
  end

  context 'search tag name with "AB"' do
    given(:search_words) { 'AABB' }

    scenario 'listed tagged "AABB" tasks' do
      expect(page.all('table tbody tr').size).to eq 1
      expect(page).to have_content('AABB', count: 1)
    end
  end
end
