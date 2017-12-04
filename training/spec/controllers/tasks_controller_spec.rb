require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  describe 'GET #index' do
    it '@tasks にタスク情報を持っている' do
      task = FactoryBot.create(:task)
      get :index
      expect(assigns(:tasks)[0]).to eq task
    end

    it 'index テンプレートを表示する' do
      get 'index'
      expect(response).to render_template :index
    end
  end
end
