# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  let(:user) { create(:user) }

  before do
    user_login(user: user)
  end

  describe 'GET #index' do
    it 'returns http success' do
      get :index, params: {}

      expect(response).to be_successful
      expect(response).to render_template('admin/users/index')
    end
  end
end
