# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Maintenances', type: :request do
  context 'when maintenance disabled' do
    it 'can displaying pages' do
      get new_session_path
      expect(response).to have_http_status(200)
    end
  end

  context 'when maintenance enabled' do
    before :all do
      File.write Rails.root.join('tmp', 'maintenance.txt'), ''
    end

    after :all do
      File.delete Rails.root.join('tmp', 'maintenance.txt')
    end

    it 'redirects to maintenance#show' do
      get new_session_path
      expect(response).to have_http_status(302)

      get response.header['Location']
      expect(response).to have_http_status(503)
      expect(response.body).to include('メンテナンス')
    end
  end
end
