require 'rails_helper'

RSpec.describe 'Under Maintenance', type: :system, js: true do
  before do
    Maintenance.create!(name: 'example maintenance', maintenance_mode: 1)
  end

  context 'when user visit under maintenance' do
    it "should be redirected to maintenance page" do
      visit tasks_path
      expect(page).to have_current_path '/en/under_maintenance'
    end
  end
end
