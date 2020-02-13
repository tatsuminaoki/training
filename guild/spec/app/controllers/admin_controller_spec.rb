# frozen_string_literal: true

require 'rails_helper'

describe AdminController, type: :request do
  let(:authority) { User.authorities[:admin] }
  let!(:user_a) { create(:user1, authority: authority) }
  let!(:login_a) { create(:login1, user_id: user_a.id) }
  let!(:user_b) { create(:user1, authority: User.authorities[:member]) }
  let!(:login_b) { create(:login1, user_id: user_b.id, email: 'login_b@example.com') }
  before do
    post '/login', params: { email: login_a.email, password: login_a.password }
  end
  describe '#index' do
    subject { get '/admin' }
    context 'Not during maintenance' do
      context 'Admin user' do
        it 'Displayed correctly' do
          subject
          expect(response).to have_http_status '200'
          expect(response.body).to include '<div class="container" id="admin-index-content">'
        end
      end
      context 'Not admin user' do
        let(:authority) { User.authorities[:member] }
        it 'Redirect to Top page' do
          subject
          expect(response).to have_http_status '302'
          expect(response).to redirect_to controller: :board, action: :index
        end
      end
    end
    context 'During maintenance' do
      it 'Redirect to Maintenance page' do
        create(:maintenance1)
        subject
        expect(response).to have_http_status '302'
        expect(response).to redirect_to controller: :maintenance, action: :index
      end
    end
  end

  describe '#users' do
    subject { get '/admin/users' }
    context 'Not during maintenance' do
      context 'Admin user' do
        it 'Displayed correctly' do
          subject
          expect(response).to have_http_status '200'
          expect(response.body).to include '<div class="container" id="admin-users-content">'
          expect(response.body).to include '<td>' + user_a.name + '</td>'
        end
      end
      context 'Not admin user' do
        let(:authority) { User.authorities[:member] }
        it 'Redirect to Top page' do
          subject
          expect(response).to have_http_status '302'
          expect(response).to redirect_to controller: :board, action: :index
        end
      end
    end
    context 'During maintenance' do
      it 'Redirect to Maintenance page' do
        create(:maintenance1)
        subject
        expect(response).to have_http_status '302'
        expect(response).to redirect_to controller: :maintenance, action: :index
      end
    end
  end

  describe '#all_users' do
    subject { get '/admin/api/user/all' }
    it 'Returned correctly' do
      subject
      expect(response).to have_http_status '200'
      response_params = JSON.parse(response.body)
      expect(response_params.count).to eq 2
      expect(response_params[0]['id']).to eq user_a.id
      expect(response_params[0]['login']['email']).to eq login_a.email
      expect(response_params[1]['id']).to eq user_b.id
      expect(response_params[1]['login']['email']).to eq login_b.email
    end
  end

  describe '#all_users' do
    subject { get '/admin/api/user/all' }
    it 'Returned correctly' do
      subject
      expect(response).to have_http_status '200'
      response_params = JSON.parse(response.body)
      expect(response_params.count).to eq 2
      expect(response_params[0]['id']).to eq user_a.id
      expect(response_params[0]['login']['email']).to eq login_a.email
      expect(response_params[1]['id']).to eq user_b.id
      expect(response_params[1]['login']['email']).to eq login_b.email
    end
  end

  describe '#add_user' do
    subject { post '/admin/api/user', params: params }
    context 'Valid params' do
      let(:params) {
        {
          'name'      => 'rspec',
          'email'     => 'rspec@example.com',
          'password'  => 'rspec',
          'authority' => User.authorities[:member],
        }
      }
      it 'Returned correctly' do
        subject
        expect(response).to have_http_status '200'
        response_params = JSON.parse(response.body)
        expect(response_params['response']).not_to eq 0
      end
    end

    context 'Invalid params' do
      let(:params) {
        {
          'name'      => 'rspec',
          'email'     => 'rspec',
          'password'  => 'rspec',
          'authority' => User.authorities[:member],
        }
      }
      it 'Returned false correctly' do
        subject
        expect(response).to have_http_status '200'
        response_params = JSON.parse(response.body)
        expect(response_params['response']).to eq false
      end
    end
  end

  describe '#delete_user' do
    subject { delete "/admin/api/user/#{user_id}" }
    context 'Valid user' do
      let(:user_id) { user_b.id }
      it 'Returned correctly' do
        subject
        expect(response).to have_http_status '200'
        response_params = JSON.parse(response.body)
        expect(response_params['result']['id']).to eq user_b.id
        expect(response_params['result']['name']).to eq user_b.name
        expect(response_params['result']['authority']).to eq user_b.authority
      end
    end
    context 'Invalid user' do
      let(:user_id) { 99_999_999 }
      it 'Returned error correctly' do
        subject
        expect(response).to have_http_status '200'
        response_params = JSON.parse(response.body)
        expect(response_params['result']).to be false
        expect(response_params['error']).to eq 'User not found'
      end
    end
    context 'Last admin user' do
      let(:user_id) { user_a.id }
      it 'Returned error correctly' do
        subject
        expect(response).to have_http_status '200'
        response_params = JSON.parse(response.body)
        expect(response_params['result']).to be false
        expect(response_params['error']).to eq 'Last admin user'
      end
    end
  end

  describe '#user' do
    let(:user_id) { user_a.id }
    subject { get '/admin/api/user/' + user_id.to_s }
    context 'Valid user' do
      it 'Returned correctly' do
        subject
        expect(response).to have_http_status '200'
        response_params = JSON.parse(response.body)
        expect(response_params['id']).to eq user_a.id
        expect(response_params['login']['email']).to eq login_a.email
      end
    end
    context 'Invalid user' do
      let(:user_id) { 999_999_999 }
      it 'Returned null correctly' do
        subject
        expect(response).to have_http_status '200'
        response_params = JSON.parse(response.body, quirks_mode: true)
        expect(response_params).to be_nil
      end
    end
  end

  describe '#change_user' do
    let(:user_id) { user_b.id }
    let(:params) {
      {
        'name'      => 'rspec',
        'email'     => 'rspec@example.com',
        'authority' => User.authorities[:admin],
      }
    }
    subject { put '/admin/api/user/' + user_id.to_s, params: params }
    context 'Valid params' do
      it 'Returned true correctly' do
        subject
        expect(response).to have_http_status '200'
        response_params = JSON.parse(response.body)
        expect(response_params['result']).to be true
      end
    end
    context 'Invalid params' do
      let(:params) {
        {
          'name'      => 'rspec',
          'email'     => 'rspec',
          'authority' => User.authorities[:admin],
        }
      }
      it 'Returned false correctly' do
        subject
        expect(response).to have_http_status '200'
        response_params = JSON.parse(response.body)
        expect(response_params['result']).to be false
      end
    end
  end
end
