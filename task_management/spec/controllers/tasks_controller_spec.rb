require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  context '存在しないパスにアクセスする' do
    # let(:request) { get :show, id: 1 }
    let(:params) {{id: 1}}
    it '404ページを読み込む' do 
      get :show, params
      expect(response).to render_template(file: "#{Rails.root}/public/404.html")
      expect(response.response_code).to eq(404)
    end
  end
end
