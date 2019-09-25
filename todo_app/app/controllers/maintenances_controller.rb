# frozen_string_literal: true

class MaintenancesController < ApplicationController
  def show
    unless File.exist?(Rails.root.join('tmp', 'maintenance.txt'))
      redirect_to(root_path, status: 302) and return
    end
    render status: 503, layout: false
  end
end
