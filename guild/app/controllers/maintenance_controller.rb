class MaintenanceController < ApplicationController
  require 'logic_maintenance'

  def index
    render template: "maintenance", :status => 503
  end

  def is_maintenance
    render :json => {
      'response' => LogicMaintenance.is_doing
    }
  end
end
