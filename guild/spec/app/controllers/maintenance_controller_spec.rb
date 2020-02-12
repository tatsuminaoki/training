require "rails_helper"
require "logic_maintenance"

describe MaintenanceController, type: :request do
  let!(:maintenance_a) { create(:maintenance1) }
  describe "#index" do
    it "Displayed correctly" do
      get "/maintenance/"
      expect(response).to have_http_status "503"
      expect(response.body).to include "<h1>During Maintenance</h1>"
    end
  end
  describe "#is_maintenance" do
    it "Return true correctly" do
      get "/maintenance/api/state"
      response_params = JSON.parse(response.body)
      expect(response).to have_http_status "200"
      expect(response.body).to_not include "<h1>During Maintenance</h1>"
    end
    it "Return false correctly" do
      LogicMaintenance.register(Time.now.ago(3.days).to_s, Time.now.ago(2.days).to_s)
      get "/maintenance/api/state"
      response_params = JSON.parse(response.body)
      expect(response).to have_http_status "200"
      expect(response_params["response"]).to be false
    end
  end
end
