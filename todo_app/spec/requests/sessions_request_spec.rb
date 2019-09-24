# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  describe 'GET /session/new' do
    context 'when logged_in' do
      before do
        user = User.create(email: 'hoge@hoge.com', password: 'passw0rd')
        allow_any_instance_of(SessionsController).to receive(:session).and_return({ user_id: user.id })
      end

      it 'redirect to /tasks' do
        get new_session_path
        expect(response).to have_http_status(302)
        expect(response.header['Location']).to include(tasks_path)
      end
    end

    context 'when not logged in' do
      it 'returns 200' do
        get new_session_path
        expect(response).to have_http_status(200)
      end

      it 'displays form' do
        get new_session_path
        expect(response.body).to match(/<input.*?session\[email\].*?>/)
        expect(response.body).to match(/<input.*?session\[password\].*?>/)
        expect(response.body).to include('<input type="submit"')
      end
    end
  end

  describe 'POST /session' do
    context 'when logged_in' do
      before do
        user = User.create(email: 'hoge@hoge.com', password: 'passw0rd')
        allow_any_instance_of(SessionsController).to receive(:session).and_return({ user_id: user.id })
      end

      it 'redirect to /tasks' do
        post session_path, params: { session: { email: 'hoge@fuga.com', password: 'hoge' } }
        expect(response).to have_http_status(302)
        expect(response.header['Location']).to include(tasks_path)
      end
    end

    context 'when not logged in' do
      context 'when failed to login' do
        it 'returns 200' do
          post session_path, params: { session: { email: 'hoge@fuga.com', password: 'hoge' } }
          expect(response).to have_http_status(200)
        end

        it 'sets flash message' do
          post session_path, params: { session: { email: 'hoge@fuga.com', password: 'hoge' } }
          expect(flash[:error]).to eq('入力された情報が正しくありません')
        end

        it 'displays form' do
          post session_path, params: { session: { email: 'hoge@fuga.com', password: 'hoge' } }
          expect(response.body).to match(/<input.*?session\[email\].*?>/)
          expect(response.body).to match(/<input.*?session\[password\].*?>/)
          expect(response.body).to include('<input type="submit"')
        end
      end

      context 'when susucceeded to login' do
        before do
          User.create(email: 'hogehoge@hoge.com', password: 'passw0rd')
        end

        it 'redirects to /tasks' do
          post session_path, params: { session: { email: 'hogehoge@hoge.com', password: 'passw0rd' } }
          expect(response).to have_http_status(302)
          expect(response.header['Location']).to include(tasks_path)
        end
      end
    end
  end

  describe 'DELETE /session' do
    it 'session[:user_id] should be blank' do
      delete session_path
      expect(session[:user_id]).to be_blank
    end

    it 'redirect to /session/new' do
      delete session_path
      expect(response).to have_http_status(302)
      expect(response.header['Location']).to include(new_session_path)
    end
  end
end
