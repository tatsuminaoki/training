class MaintenanceController < ApplicationController
  require "logic_maintenance"

  def index
    render template: "maintenance", status: 503
  end

  def maintenance?
    render json: {
      "response" => LogicMaintenance.doing?
    }
  end
end
