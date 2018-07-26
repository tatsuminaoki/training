require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  context '存在しないパスにアクセスする' do
    let(:user) {FactoryBot.create(:user)}
    before do
      session[:user_id] = user.id
    end
    it '404ページを読み込む' do 
      get :show, params: {id: 99999}
      expect(response).to render_template(file: "#{Rails.root}/public/404.html")
      expect(response.response_code).to eq(404)
    end
  end
end
