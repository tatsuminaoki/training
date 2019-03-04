require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  describe "GET #index" do
    let(:user) {create(:user)}
    before do
      session[:user_id] = user.id
    end

    it "respons success with 200 http status code" do
      get :index
      expect(response).to be_successful
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end
    
  end
end