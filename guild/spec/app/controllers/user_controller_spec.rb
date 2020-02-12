require "rails_helper"
require "logic_maintenance"

describe UserController, type: :request do
  let!(:user_a) { create(:user1) }
  let!(:login_a) { create(:login1, user_id: user_a.id) }
  describe "#login_top" do
    it "Displayed correctly" do
      get "/login"
      expect(response).to have_http_status "200"
      expect(response.body).to include '<h2 class="h3 mb-3 font-weight-normal">Please sign in</h2>'
    end
  end

  describe "#login" do
    context "Valid login params" do
      it "Returned correctly" do
        post "/login", params: { "email" => login_a.email, "password" => login_a.password }
        expect(response).to have_http_status "200"
        response_params = JSON.parse(response.body)
        expect(response_params["response"]["result"]).to be true
        expect(response_params["response"]["errors"].count).to eq 0

        expect(session[:me].count).to eq 2
        expect(session[:me][:user_id]).to eq user_a.id
        expect(session[:me][:name]).to eq user_a.name
      end
    end
    context "Invalid login params" do
      context "Invalid email" do
        it "Returned errors" do
          post "/login", params: { "email" => "test", "password" => login_a.password }
          expect(response).to have_http_status "200"
          response_params = JSON.parse(response.body)
          expect(response_params["response"]["result"]).to be false
          expect(response_params["response"]["errors"].count).to eq 1
          expect(response_params["response"]["errors"][0]).to eq "email"
        end
      end
      context "Invalid password" do
        it "Returned errors" do
          post "/login", params: { "email" => login_a.email, "password" => "testtest" }
          expect(response).to have_http_status "200"
          response_params = JSON.parse(response.body)
          expect(response_params["response"]["result"]).to be false
          expect(response_params["response"]["errors"].count).to eq 1
          expect(response_params["response"]["errors"][0]).to eq "password"
        end
      end
    end
  end
  describe "#logout" do
    it "Returned correctly" do
      post "/login", params: { "email" => login_a.email, "password" => login_a.password }
      get "/logout"
      expect(response).to have_http_status "200"
      response_params = JSON.parse(response.body)
      expect(response_params["response"]["result"]).to be true

      expect(session[:me].blank?).to be true
    end
  end
end
