class MaintenanceController < ApplicationController
  skip_before_action :is_maintenance

  def under_maintenance
  end
end
