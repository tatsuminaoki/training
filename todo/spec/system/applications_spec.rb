# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Applications', type: :system do
  let!(:site_setting) { create(:site_setting, maintenance: maintenance) }

  context 'When maintenance mode on' do
    let(:maintenance) { :on }
    it 'returns 503' do
      visit login_path
      expect(page).to have_content '503'
    end
  end

  context 'When maintenance mode off' do
    let(:maintenance) { :off }
    it 'returns 200' do
      visit login_path
      expect(page).not_to have_content '503'
    end
  end
end
