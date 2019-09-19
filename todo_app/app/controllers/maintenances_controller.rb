# frozen_string_literal: true

class MaintenancesController < ApplicationController
  def show
    if !File.exist?(Rails.root.join('tmp', 'maintenance.txt'))
      redirect_to root_path, status: 302
    else
      render status: 503, layout: false
    end
  end
end
