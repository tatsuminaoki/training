# frozen_string_literal: true

module ApplicationHelper
  def active_controller(controller)
    return 'active' if controller == params[:controller]
  end
end
