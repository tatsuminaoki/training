# frozen_string_literal: true

require 'rails_helper'
require 'value_objects/authority'

describe AdminController, type: :request do
  let(:authority) { ValueObjects::Authority::ADMIN }
  let!(:user_a) { create(:user1, authority: authority) }
  let!(:login_a) { create(:login1, user_id: user_a.id) }
  before do
    post '/login', params: { email: login_a.email, password: login_a.password }
  end
  describe '#index' do
    context 'Not during maintenance' do
      context 'Admin user' do
        it 'Displayed correctly' do
          get '/admin'
          expect(response).to have_http_status '200'
          expect(response.body).to include '<div class="container" id="admin-index-content">'
        end
      end
      context 'Not admin user' do
        let(:authority) { ValueObjects::Authority::MEMBER }
        it 'Displayed correctly' do
          get '/admin'
          expect(response).to have_http_status '302'
          expect(response).to redirect_to controller: :board, action: :index
        end
      end
    end
    context 'During maintenance' do
      it 'Displayed correctly' do
        create(:maintenance1)
        get '/admin'
        expect(response).to have_http_status '302'
        expect(response).to redirect_to controller: :maintenance, action: :index
      end
    end
  end
end
